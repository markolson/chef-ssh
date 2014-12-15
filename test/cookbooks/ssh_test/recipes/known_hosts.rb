# Author: Tejay Cardon

include_recipe 'ssh'

file '/etc/ssh/ssh_known_hosts' do
  content "#{::TestData.dummy1_key}\n#{::TestData.dummy2_key}\n"
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
