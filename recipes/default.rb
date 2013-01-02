#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2013, Mark Olson
#
# All rights reserved - Do Not Redistribute
#

ssh_known_hosts "github.com" do
  hashed true
  user 'vagrant'
end
