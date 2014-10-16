# Author: Tejay Cardon

include_recipe 'ssh'

ssh_known_hosts "github.com" do
  hashed false
  user 'root'
end