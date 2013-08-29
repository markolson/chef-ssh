include_recipe 'ssh'

ssh_known_hosts "github.com" do
  hashed false
  user 'root'
end

ssh_config "github.com" do
  options 'User' => 'git', 'IdentityFile' => '/tmp/gh'
  user 'root'
end

ssh_known_hosts "github.com" do
  hashed true
  user 'vagrant'
end

ssh_config "github.com" do
  options 'User' => 'git', 'IdentityFile' => '/tmp/gh'
  user 'vagrant'
end


user "faked" do
  comment "Not A Real Person"
  uid 1000
  gid "users"
  system true
  home "/tmp/bitty"
  shell "/bin/zsh"
  password "weeeeeeeeeeeee"
end

ssh_known_hosts "github.com" do
  hashed false
  user 'faked'
end

ssh_config "github.com" do
  options 'User' => 'git', 'IdentityFile' => '/tmp/gh'
  user 'faked'
end
