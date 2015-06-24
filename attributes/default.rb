default['ssh']['known_hosts_path'] = '/etc/ssh/ssh_known_hosts'
default['ssh']['config_path'] = '/etc/ssh/ssh_config'

case node['platform_family']
when 'debian'
  default['ssh']['packages'] = ['ssh']
when 'rhel'
  default['ssh']['packages'] = ['openssh-server', 'openssh-clients']
else
  default['ssh']['packages'] = ['ssh']
end
