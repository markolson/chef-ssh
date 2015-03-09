require 'spec_helper'

describe 'ssh_config resource' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(:step_into => :ssh_config)
    runner.converge('ssh_test::known_hosts')
  end

  let(:default_known_hosts) { '/etc/ssh/ssh_known_hosts' }
  let(:vagrant_known_hosts) { '/home/vagrant/.ssh/known_hosts' }

  let(:test_user) { 'someone' }
  let(:test_group) { 'other_group' }
  let(:test_known_hosts) { '/some/random/path/config' }

  before do
    allow(Etc).to receive(:getpwnam)
    allow(Etc).to receive(:getpwnam).with(test_user).and_return(
      Struct.new(:gid, :dir).new(200, "/home/#{test_user}")
    )
    allow(Etc).to receive(:getpwnam).with('root').and_return(
      Struct.new(:gid).new(0)
    )
  end

  pending 'I can not think of any spec tests that make sense'
end
