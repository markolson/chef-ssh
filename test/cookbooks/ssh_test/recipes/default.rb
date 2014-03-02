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

ohai "reload_passwd" do
  action :nothing
  plugin "passwd"
end

user "faked" do
  comment "Not A Real Person"
  uid 1000
  system true
  home "/tmp/bitty"
  shell "/bin/zsh"
  password "weeeeeeeeeeeee"
  notifies :reload, "ohai[reload_passwd]", :immediately
end

ssh_known_hosts "github.com" do
  hashed false
  user 'faked'
end

ssh_config "github.com" do
  options 'User' => 'git', 'IdentityFile' => '/tmp/gh'
  user 'faked'
end

ssh_known_hosts "gitlab.com:22" do
  hashed false
  user 'faked'
end

ssh_authorized_key 'root@default-ubuntu-1204.vagrantup.com' do
  key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOIKQ3P4ZM5GtkwdWmDfWm7UKp7lkiwV5zjyXvV6S2c5fw8AxYRzFuUtOFhhY5/AHrhHvKDRMcnvRGwL4Em58Fg1a0OKwSUwJoMuD2HXY50AkTbIWtZChXIOU/Bm7sJxO3FY1oXHLq2IYQEy7u77PMU54ticnFZetXfxEGgyekuZRLyyO6lQwAmE+nGWlyMEIc03U8mTtCYRmrc71JXm2MR8xAyo0ccukwhrDEM4FesmDDT9iNQGE1wdHcIXDNpfYIng6xwFGJPVwGiHedb7otiTf8kePTnbCR8SjPUpr2QdAYl+ofHmRtO0vP59NxQHUeuSOYBDZx1c7XHB3Ho5AT'
  user 'vagrant'
end

ssh_authorized_key 'root@default-ubuntu-1204.vagrantup.com for root' do
  key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOIKQ3P4ZM5GtkwdWmDfWm7UKp7lkiwV5zjyXvV6S2c5fw8AxYRzFuUtOFhhY5/AHrhHvKDRMcnvRGwL4Em58Fg1a0OKwSUwJoMuD2HXY50AkTbIWtZChXIOU/Bm7sJxO3FY1oXHLq2IYQEy7u77PMU54ticnFZetXfxEGgyekuZRLyyO6lQwAmE+nGWlyMEIc03U8mTtCYRmrc71JXm2MR8xAyo0ccukwhrDEM4FesmDDT9iNQGE1wdHcIXDNpfYIng6xwFGJPVwGiHedb7otiTf8kePTnbCR8SjPUpr2QdAYl+ofHmRtO0vP59NxQHUeuSOYBDZx1c7XHB3Ho5AT'
  key_identifier 'root@default-ubuntu-1204.vagrantup.com'
end

ssh_authorized_key 'root2@default-ubuntu-1204.vagrantup.com' do
  key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVYvDSDGEAwM80s8j8OnPWa9eUthRVb/NKbYGGSOL392p5PmvKR8iCOZudfWRy3KLsYZiUPBLUeUsZ4TavNDB/C8a0eVKr3UEN2RlsT9ciik2uFoVF8WXI97KbeOg3NxaC/EhmZ4k0dD86Fs7qNe9uiiEbLVKkUkvUJFv25QQXywe3xONnhGfjwVx1nk7tcuu09ZI8uTMV6CQWaOqZwS3TLP1pr7yQ1HQusPCv/ZG42gjuFP5CjvTxIYXMdF9NRM+qGrN9nQDUFrHjf6sZ1KzOr5372sn7ZxjTq1eGUtE3eL1ufW88zS4m3NiFyaCpd3FWZ6inlrIR7ekGKcuvegwL'

  user 'vagrant'
end
