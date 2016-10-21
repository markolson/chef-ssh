# Author: Tejay Cardon

include_recipe 'ssh'

file '/etc/ssh/ssh_known_hosts' do
  content "#{::TestData.dummy1_key}\n#{::TestData.dummy2_key}\n"\
          "#{::TestData.dummy6_key}\n"
  action :create
end

file '/home/vagrant/.ssh/known_hosts' do
  content "#{::TestData.dummy3_key}\n#{::TestData.dummy4_key}\n"
  action :create
end

ssh_known_hosts 'github.com' do
  hashed false
end

ssh_known_hosts 'github.com' do
  hashed true
  user   'vagrant'
  port   22
end

# Simulate multiple converges to test idempotence
(1..3).step do |n|
  ssh_known_hosts "altssh.bitbucket.org converge #{n}" do
    host 'altssh.bitbucket.org'
    port 443
    user 'root'
    key ::TestData.bitbucket_altssh_key
  end
end

ssh_known_hosts 'some entry' do
  host 'test_host'
  user 'vagrant'
  key  node['ssh_test']['known_hosts']['test_entry']
end

ssh_known_hosts 'dummy5' do
  key node['ssh_test']['known_hosts']['test_entry']
end

ssh_known_hosts 'dummy2' do
  action :remove
end

ssh_known_hosts 'dummy4' do
  user   'vagrant'
  action :remove
end

ssh_known_hosts 'dummy6' do
  host 'dummy6'
  port 234
  user 'vagrant'
  key ::TestData.dummy6_key
end
