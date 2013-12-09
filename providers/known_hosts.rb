require 'shellwords'
include Chef::SSH::PathHelpers

action :add do
  ssh_user = new_resource.user || 'root'
  known_hosts_path = default_or_user_path(node['ssh']['known_hosts_path'], ssh_user)
  host, port = new_resource.host.split(':')

  key = new_resource.key
  if key.nil?
    port_arg = port.nil? ? '' : "-p #{port}"
    results = `ssh-keyscan #{new_resource.hashed ? '-H ' : ''} #{port_arg} #{Shellwords.escape(host)}`
    Chef::Application.fatal! results.strip if key =~ /getaddrinfo/
    key = results.strip
  end

  execute "add known_host entry for #{host}" do
    not_if "ssh-keygen -H -F #{Shellwords.escape(host)} -f #{known_hosts_path} | grep 'Host #{host} found'"
    command "echo '#{key}' >> #{known_hosts_path}"
    user ssh_user
  end

  Chef::Log.debug "An entry for #{host} already exists in #{known_hosts_path}." do
    only_if "ssh-keygen -H -F #{Shellwords.escape(host)} -f #{known_hosts_path} | grep 'Host #{host} found'"
  end
end

action :remove do
  ssh_user = new_resource.user || 'root'
  known_hosts_path = default_or_user_path(node['ssh']['known_hosts_path'], ssh_user)
  execute "remove known_host entry for #{new_resource.host}" do
    command "ssh-keygen -R #{Shellwords.escape(new_resource.host)}"
    user ssh_user
    umask '0600'
  end
end
