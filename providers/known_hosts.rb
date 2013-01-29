require 'shellwords'
include Chef::SSH::PathHelpers

action :add do
  ssh_user = new_resource.user || 'root'
  known_hosts_path = default_or_user_path(node['ssh']['known_hosts_path'], ssh_user)

  key = new_resource.key
  if key.nil?
    results = `ssh-keyscan #{new_resource.hashed ? '-H ' : ''} #{Shellwords.escape(new_resource.host)}`
    Chef::Application.fatal! results.strip if key =~ /getaddrinfo/
    key = results.strip
  end

  execute "add known_host entry for #{new_resource.host}" do
    not_if "ssh-keygen -H -F #{Shellwords.escape(new_resource.host)} -f #{known_hosts_path} | grep 'Host #{new_resource.host} found'"
    command "echo '#{key}' >> #{known_hosts_path}"
    user ssh_user
  end

  log "An entry for #{new_resource.host} already exists in #{known_hosts_path}." do
    only_if "ssh-keygen -H -F #{Shellwords.escape(new_resource.host)} -f #{known_hosts_path} | grep 'Host #{new_resource.host} found'"
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
