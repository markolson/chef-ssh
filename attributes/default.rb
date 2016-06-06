default['ssh']['known_hosts_path'] = '/etc/ssh/ssh_known_hosts'
default['ssh']['config_path'] = '/etc/ssh/ssh_config'

default['ssh']['packages'] = case node['platform_family']
                             when 'rhel'
                               ['openssh-server', 'openssh-clients']
                             else
                               ['ssh']
                             end
