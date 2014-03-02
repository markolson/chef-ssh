
action :add do
  key = new_resource.key
  ssh_user = new_resource.user || 'root'
  ssh_path = new_resource.path || "#{node['etc']['passwd'][ssh_user]['dir']}/.ssh/authorized_keys"

  directory "Creating #{::File.dirname(ssh_path)} for #{ssh_user}" do
    owner ssh_user
    mode '0700'
    recursive true
    path ::File.dirname(ssh_path)
    user ssh_user
  end

  keyfile = ''
  keyfile = IO::File.read(ssh_path) if IO::File.exists?(ssh_path)
  Chef::Log.info("keyfile at #{ssh_path} contains '#{keyfile}'")

  unless keyfile.include?(key)
    keyfile += "\n" if keyfile.length() > 0 and not keyfile.end_with?("\n")
    keyfile = "#{keyfile}#{key} #{new_resource.key_identifier}\n"
  end

  file ssh_path do
    content keyfile
    user ssh_user
    mode 0600
  end
end
