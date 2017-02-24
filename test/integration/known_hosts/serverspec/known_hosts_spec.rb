require 'spec_helper'
require_relative 'test_data'

describe file('/etc/ssh/ssh_known_hosts') do
  it { should be_file }
  it { should be_readable }
  its(:content) { should include(TestData.github_key) }
  its(:content) { should include(TestData.dummy1_key) }
  its(:content) { should_not match(/dummy2/) }
  its(:content) { is_expected.to contain('# this is a comment') }
end

describe file('/home/vagrant/.ssh/known_hosts') do
  it { should be_file }
  it { should be_readable }
  its(:content) { should include(TestData.dummy3_key) }
  its(:content) { should_not match(/dummy4/) }
  its(:content) { is_expected.to contain('# this is a comment') }
end

describe command('ssh-keygen -F github.com -f /home/vagrant/.ssh/known_hosts') do
  its(:stdout) { should include(TestData.github_key.split(' ')[2]) }
  its(:stdout) { should match(/found/) }
end

describe command('ssh-keygen -F [altssh.bitbucket.org]:443 -f /root/.ssh/known_hosts | grep found | wc -l') do
  its(:stdout) { should match(/1/) }
end

describe file('/home/vagrant/.ssh/known_hosts') do
  it { should be_file }
  its(:content) { should match(/\[dummy6\]\:234 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwDBTE5H\+DpOWUv3CPtOo/) }
  its(:content) { should_not match(/\[dummy6\]\:234[\s\S]*\[dummy6\]\:234/) }
end
