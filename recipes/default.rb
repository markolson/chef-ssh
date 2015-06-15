# Author: Tejay Cardon
# Cookbook: ssh
# Recipe: default.rb

if node[:platform_faily].include?("debian")
  package 'ssh' do
    action :install
  end
end
