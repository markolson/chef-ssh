# Author: Tejay Cardon
# Cookbook: ssh
# Recipe: default.rb

node['ssh']['packages'].each do |package_name|
  package package_name
end
