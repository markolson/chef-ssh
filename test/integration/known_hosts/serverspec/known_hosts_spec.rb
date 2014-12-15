require 'spec_helper'
require_relative 'test_data'

describe file('/etc/ssh/ssh_known_hosts') do
  it { should be_file }
  it { should be_readable }
  its(:content) { should include(TestData.github_key) }
  its(:content) { should include(TestData.dummy1_key) }
  its(:content) { should_not match(/dummy2/) }
end

describe file('/home/vagrant/.ssh/known_hosts') do
  it { should be_file }
  it { should be_readable }
  its(:content) { should include(TestData.dummy3_key) }
  its(:content) { should_not match(/dummy4/) }
end

describe command('ssh-keygen -F github.com -f /home/vagrant/.ssh/known_hosts') do
  its(:stdout) { should include(TestData.github_key.split(' ')[2]) }
  its(:stdout) { should match(/found/) }
end
