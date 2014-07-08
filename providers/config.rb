include Chef::SSH::PathHelpers
action :add do
  ssh_user = new_resource.user || 'root'
  ssh_config_path = default_or_user_path(node['ssh']['config_path'], ssh_user)

  remove_entry(ssh_config_path, ssh_user)
  add_entry(ssh_config_path, ssh_user)
  set_rights_proper(ssh_config_path, ssh_user)
end

action :remove do
  ssh_user = new_resource.user || 'root'
  ssh_config_path = default_or_user_path(node['ssh']['config_path'], ssh_user)

  remove_entry(ssh_config_path, ssh_user)
end

def remove_entry(config_file, ssh_user)
  execute "remove #{new_resource.host} from #{config_file}" do
    command "ruby -e \"x =  $<.read; x.gsub!(/[\\n]{0,1}Host #{new_resource.host.strip}.*#End Chef SSH for #{new_resource.host.strip}/m,''); puts x\" #{config_file} > #{config_file}.new && mv #{config_file}.new #{config_file}"
    user ssh_user unless node['platform_family'] == "windows"
    group ssh_user unless node['platform_family'] == "windows"
    only_if "grep \"#{new_resource.host}\" #{config_file}"
  end
end

def add_entry(config_file, ssh_user)
  execute "add #{new_resource.host} to #{config_file}" do
    command "#{config_command} >> #{config_file}"
    user ssh_user unless node['platform_family'] == "windows"
    group ssh_user unless node['platform_family'] == "windows"
    umask 600
  end
end

def config_command
  if node['platform_family'] == "windows"
    "( echo #{config_fragment.join(" & echo ")} )"
  else
    "echo '#{config_fragment.join("\n")}'"
  end
end

def config_fragment
  x = ["Host #{new_resource.host.strip}"]
  new_resource.options.each_with_object(x) {|(key, value), array|
    array << "  #{key} #{value.strip}"
  }
  x << "#End Chef SSH for #{new_resource.host.strip}"
  x
end

def set_rights_proper(config_file, ssh_user)
  file "#{config_file}" do
    owner ssh_user
    group ssh_user
    mode "0600"
    action :create
  end
end

