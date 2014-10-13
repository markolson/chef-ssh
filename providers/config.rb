include Chef::SSH::PathHelpers
action :add do
  ssh_user = new_resource.user || 'root'
  ssh_group = new_resource.group || ssh_user
  ssh_config_path = default_or_user_path(node['ssh']['config_path'], ssh_user)

  remove_entry(ssh_config_path, ssh_user, ssh_group)
  add_entry(ssh_config_path, ssh_user, ssh_group)
  set_rights_proper(ssh_config_path, ssh_user, ssh_group)
end

action :remove do
  ssh_user = new_resource.user || 'root'
  ssh_group = new_resource.group || ssh_user
  ssh_config_path = default_or_user_path(node['ssh']['config_path'], ssh_user)

  remove_entry(ssh_config_path, ssh_user)
end

def remove_entry(config_file, ssh_user, ssh_group)
  execute "remove #{new_resource.host} from #{config_file}" do
    command "ruby -e 'x =  $<.read; x.gsub!(/^[\n]{0,1}Host #{Regexp.escape(new_resource.host.strip)}.*#End Chef SSH for #{Regexp.escape(new_resource.host.strip)}\n/m,\"\"); puts x' #{config_file} > #{config_file}.new && mv #{config_file}.new #{config_file}"
    user ssh_user
    group ssh_group
    only_if "grep \"#{Regexp.escape(new_resource.host)}\" #{config_file}"
  end
end

def add_entry(config_file, ssh_user, ssh_group)
  execute "add #{new_resource.host} to #{config_file}" do
    command "echo '#{config_fragment}' >> #{config_file}"
    user ssh_user
    group ssh_group
    umask 600
  end
end

def config_fragment
  x = "Host #{new_resource.host.strip}\n"
  new_resource.options.each {|key, value|
    x += "  #{key} #{value.to_s.strip}\n"
  }
  x += "#End Chef SSH for #{new_resource.host.strip}\n"
  return x
end

def set_rights_proper(config_file, ssh_user, ssh_group)
  file "#{config_file}" do
    owner ssh_user
    group ssh_group
    mode "0600"
    action :create
  end
end

