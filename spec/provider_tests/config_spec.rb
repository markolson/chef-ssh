require 'spec_helper'

describe 'ssh_config resource' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(:step_into => :ssh_config)
    runner.converge('ssh_test::config')
  end

  let(:default_config) { '/etc/ssh/ssh_config' }
  let(:vagrant_config) { '/home/vagrant/.ssh/config' }

  let(:test_user) { 'someone' }
  let(:test_group) { 'other_group' }
  let(:test_config) { '/some/random/path/config' }

  let(:partial_start) do
    content = []
    content << 'Host somewhere'
    content << 'not indented'
    content << 'and_also_with=equal sign'
    content << 'Host second with extra patterns'
    content << '  Extra_spaces    did_not_matter'
    content << '  HostName option is correctly matched'
    content << '  Multiple_words not a problem'
    content << '  We "can handle quotes"'
  end

  let(:common_end) do
    content = []
    content << '# Created by Chef for chefspec.local'
    content << ''
  end

  let(:partial_end) do
    content = []
    content << 'Host somewhere'
    content << '  not indented'
    content << '  and_also_with =equal sign'
    content << ''
    content << 'Host second with extra patterns'
    content << '  Extra_spaces did_not_matter'
    content << '  HostName option is correctly matched'
    content << '  Multiple_words not a problem'
    content << '  We "can handle quotes"'
    content << ''
  end

  let(:github_end) do
    content = []
    content << 'Host github.com'
    content << '  User git'
    content << '  IdentityFile /tmp/gh'
    content << ''
  end

  let(:test_end) do
    content = []
    content << 'Host test.io'
    content << '  User testuser'
    content << '  DummyKey I was allowed'
    content << ''
  end

  let(:github_and_partial_end) do
    partial_end + github_end
  end

  let(:test_and_partial_end) do
    partial_end + test_end
  end

  before do
    allow(::File).to receive(:'exist?')
    allow(::File).to receive(:'exist?').with(vagrant_config).and_return(true)
    allow(::File).to receive(:'exist?').with(default_config).and_return(true)
    allow(::File).to receive(:'exist?').with(test_config).and_return(true)

    allow(IO).to receive(:foreach)
    allow(IO).to partial_start.reduce(receive(:foreach).with(vagrant_config), :and_yield)
    allow(IO).to partial_start.reduce(receive(:foreach).with(default_config), :and_yield)
    allow(IO).to partial_start.reduce(receive(:foreach).with(test_config), :and_yield)

    allow(Etc).to receive(:getgrgid).and_raise(Exception.new('This should not happen'))
    allow(Etc).to receive(:getgrgid).with(200).and_return(Struct.new(:name).new('vagrant'))
    allow(Etc).to receive(:getgrgid).with(100).and_return(Struct.new(:name).new('someone'))
    allow(Etc).to receive(:getgrgid).with(0).and_return(Struct.new(:name).new('root'))

    allow(Etc).to receive(:getpwnam).and_raise(Exception.new('This should not happen'))
    allow(Etc).to receive(:getpwnam).with('vagrant').and_return(
      Struct.new(:gid, :dir).new(200, '/home/vagrant')
    )
    allow(Etc).to receive(:getpwnam).with('someone').and_return(
      Struct.new(:gid).new(100)
    )
    allow(Etc).to receive(:getpwnam).with('root').and_return(
      Struct.new(:gid).new(0)
    )
  end

  it 'works when no config file currently exists' do
    allow(::File).to receive(:'exist?').with(default_config).and_return(false)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_end).join("\n")
    )
  end

  it 'maintains existing config entries' do
    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles configs with "=" signs in them' do
    expect(partial_start.join("\n")).to match(/^\s*\w+\s*=\s*\w/)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles configs with extra whitespace between keywords and arguments' do
    expect(partial_start.join("\n")).to match(/^\s*\w+\s\s+\w/)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles configs that do not indent' do
    host_lines_removed = partial_start.reject { |line| line.match(/^[h|H]ost/) }
    expect(host_lines_removed.join("\n")).to match(/^\w+\s+\w+/)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles host declarations with multiple patterns' do
    host_lines_only = partial_start.select { |line| line.match(/^[h|H]ost/) }
    expect(host_lines_only.join("\n")).to match(/^\w+\s+\w+\s+\w+/)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles config elements with quotes' do
    expect(partial_start.join("\n")).to match(/^\s*\w+\s+".+"/)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles config elements with multiple words' do
    host_lines_removed = partial_start.reject { |line| line.match(/^[h|H]ost/) }
    expect(host_lines_removed.join("\n")).to match(/^\s*\w+\s+\w+\s+\w+/)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'properly handles config without empty lines between configs' do
    found_one = false
    partial_start.each_with_index do |line, index|
      found_one = true if line.match(/^\s*[H|h]ost/) && !partial_start[index].empty?
      break if found_one
    end
  end

  it 'can create user ssh configs' do
    expect(chef_run).to create_file(vagrant_config).with(
      :owner => 'vagrant',
      :group => 'vagrant',
      :mode => 00600
    ).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'can create the global ssh config' do
    expect(chef_run).to create_file(default_config).with(
      :owner => 'root',
      :group => 'root',
      :mode => 00644
    ).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'creates the /etc/ssh directory if it is missing' do
    expect(chef_run).to create_directory(::File.dirname(default_config)).with(
      :owner => 'root',
      :group => 'root',
      :mode => 00755
    )
  end

  it "creates vagrant's ~/.ssh/config file" do
    expect(chef_run).to create_directory(::File.dirname(vagrant_config)).with(
      :owner => 'vagrant',
      :group => 'vagrant',
      :mode => 00700
    )
  end

  context 'when non-default attributes are used' do
    it 'can handle a custom path' do
      expect(chef_run).to render_file(test_config).with_content(
        (common_end + test_and_partial_end).join("\n")
      )
    end

    it 'can handle a custom owner and group for the config file' do
      expect(chef_run).to create_file(test_config).with(
        :owner => test_user,
        :group => test_group,
        :mode => 00600
      )
    end
  end

  it 'can handle files with comments in them' do
    content = []
    content << '# this is a comment line'
    content += partial_start
    allow(IO).to content.reduce(receive(:foreach).with(default_config), :and_yield)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end

  it 'does not duplicate entries' do
    allow(IO).to github_and_partial_end.reduce(receive(:foreach).with(vagrant_config), :and_yield)

    expect(chef_run).to render_file(default_config).with_content(
      (common_end + github_and_partial_end).join("\n")
    )
  end
end
