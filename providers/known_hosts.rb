require 'shellwords'
require 'mixlib/shellout'

include Chef::SSH::Helpers

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  unless @current_resource.exists?
    directory ::File.basename(new_resource.path) do
      action :create
      owner  new_resource.user if new_resource.user
      group  new_resource.group if new_resource.group
      mode   new_resource.user ? 00700 : 00755
    end

    file new_resource.path do
      action :create
      mode   new_resource.user ? 00600 : 00644
      owner  new_resource.user if new_resource.user
      group  new_resource.group if new_resource.group
    end

    execute "add known_host entry for #{new_resource.host}" do
      command "echo '#{new_resource.key}' >> #{new_resource.path}"
      user    new_resource.user if new_resource.user
      umask   new_resource.user ? 0077 : 0022
    end
  end
end

action :remove do
  if @current_resource.exists?
    execute "remove known_host entry for #{new_resource.host}" do
      command "ssh-keygen -R #{Shellwords.escape(new_resource.host)} -f #{new_resource.path}"
      user    new_resource.user if new_resource.user
      umask   new_resource.user ? 0077 : 0022
    end
  end
end

def initialize(new_resource, run_context)
  super(new_resource, run_context)

  new_resource.path default_or_user_path(new_resource.user) unless new_resource.path
  if new_resource.host.match(/:/)
    host, port = new_resource.host.split(':')
    new_resource.host host
    new_resource.port port unless new_resource.port
  end

  new_resource.port 22 unless new_resource.port

  new_resource.group user_group(new_resource.user) unless new_resource.group

  load_current_resource
  load_key_if_needed
end

def load_key_if_needed
  return if @current_resource.exists?
  return if new_resource.key
  return if new_resource.action.is_a?(Array) ? new_resource.action.include?(:remove) : new_resource.action == :remove

  keyscan = Mixlib::ShellOut.new(
    "ssh-keyscan #{new_resource.hashed ? '-H ' : ''} -p #{new_resource.port.to_i} #{Shellwords.escape(new_resource.host)}"
  )
  keyscan.run_command
  keyscan.error! # this will raise an error if the command failed for any reason.
  new_resource.key keyscan.stdout.strip
end

def load_current_resource
  search = Mixlib::ShellOut.new(
    "ssh-keygen -H -F #{Shellwords.escape(new_resource.host)} "\
    "-f #{new_resource.path} | grep 'Host #{new_resource.host} found'"
  )
  search.run_command
  @current_resource = Chef::Resource::SshKnownHosts.new(@new_resource.name)
  @current_resource.exists = search.status.success?
end

protected

def default_or_user_path(username = nil)
  username ? "#{user_dir(username)}/.ssh/known_hosts" : node['ssh']['known_hosts_path']
end
