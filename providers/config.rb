include Chef::SSH::PathHelpers
action :add do
  ssh_user = new_resource.user || 'root'
  known_hosts_path = default_or_user_path(node['ssh']['config_path'], ssh_user)

  remove_entry(known_hosts_path, ssh_user)
  add_entry(known_hosts_path, ssh_user)

end

action :remove do
  ssh_user = new_resource.user || 'root'
  known_hosts_path = default_or_user_path(node['ssh']['config_path'], ssh_user)

  remove_entry(known_hosts_path, ssh_user)
end

def remove_entry(config_file, ssh_user)
  execute "remove #{new_resource.host} from #{config_file}" do
    command "ruby -e 'x =  $<.read; x.gsub!(/^[\n]{0,1}Host #{new_resource.host.strip}.*#End Chef SSH for #{new_resource.host.strip}\n/m,\"\"); puts x' #{config_file} > #{config_file}.new && mv #{config_file}.new #{config_file}"
    user ssh_user
    group ssh_user
    only_if "grep \"#{new_resource.host}\" #{config_file}"
  end
end

def add_entry(config_file, ssh_user)
  execute "add #{new_resource.host} to #{config_file}" do
    command "echo '#{config_fragment}' >> #{config_file}"
    user ssh_user
    group ssh_user
    umask 600
  end
end

def config_fragment
  x = "Host #{new_resource.host.strip}\n"
  new_resource.options.each {|key, value|
    x += "  #{key} #{value.strip}\n"
  }
  x += "#End Chef SSH for #{new_resource.host.strip}\n"
  return x
end
