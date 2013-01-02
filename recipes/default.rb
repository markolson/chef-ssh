#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2013, Mark Olson
#
# All rights reserved - Do Not Redistribute
#

ssh_known_hosts "syntaxi.net" do
  hashed true
  user 'vagrant'
end


ssh_config "syntaxi.net" do
  action :destroy
  user 'vagrant'
end

ssh_config "syntaxi2.net" do
  options 'User' => 'syntaxin'
  user 'vagrant'
end

ssh_config "github.com" do
  options 'User' => 'git', 'IdentityFile' => '~/.ssh/github_key'
  user 'vagrant'
end
