include Chef::SSH::ConfigHelpers

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  return if @new_resource.options.eql? @existing_entries[new_resource.name]
  @existing_entries[@new_resource.name] = @new_resource.options

  converge_by "Adding {@new_resource.name} to #{@path} with #{new_resource.options.inspect}" do
    create_directory
    create_file
  end
end

action :add_if_missing do
  action_add unless @current_resource.exists?
end

action :remove do
  return unless @current_resource.exists?
  @existing_entries.delete @new_resource.name

  converge_by "Remove #{@new_resource.name} from #{@path}" do
    create_file
  end
end

def create_directory
  directory "Creating #{::File.dirname(@path)} for #{@user}" do
    owner     @user
    group     @group if @group
    mode      default?(@path) ? 00755 : 00700
    path      ::File.dirname(@path)
    recursive true
  end
end

def create_file
  existing_entries = @existing_entries
  file @path do
    user    @user if @user
    group   @group if @group
    mode    default?(@path) ? 00644 : 00600
    content "# Created by Chef for #{node.name}\n\n#{to_config(existing_entries)}"
  end
end

def load_current_resource
  @user = new_resource.user || 'root'
  @group = new_resource.group || pwent_for(@user).gid
  @path = new_resource.path || default_or_user_path(new_resource.user)
  @existing_entries = parse_file @path

  @current_resource = Chef::Resource::SshConfig.new(@new_resource.name)
  @current_resource.exists = @existing_entries.key? @new_resource.name
end

