# Author: Tejay Cardon

include_recipe 'ssh'

ssh_config 'github.com' do
  options 'User' => 'git', 'IdentityFile' => '/tmp/gh'
end

ssh_config 'github.com' do
  options 'User' => 'git', 'IdentityFile' => '/tmp/gh'
  user 'vagrant'
end

ssh_config 'test.io' do
  options 'User' => 'testuser', 'DummyKey' => 'I was allowed'
  user  'someone'
  group 'other_group'
  path  '/some/random/path/config'
end
