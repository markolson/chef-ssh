include Chef::SSH::ConfigHelpers

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  unless @new_resource.options.eql? @existing_entries[new_resource.name]
    @existing_entries[@new_resource.name] = @new_resource.options

    converge_by "Adding {@new_resource.name} to #{@path} with #{new_resource.options.inspect}" do
      create_directory
      create_file
    end
  end
end

action :add_if_missing do
  action_add unless @current_resource.exists?
end

action :remove do
  if @current_resource.exists?
    @existing_entries.delete @new_resource.name

    converge_by "Remove #{@new_resource.name} from #{@path}" do
      create_file
    end
  end
end

def create_directory
  d = directory ::File.dirname(@path)
  d.owner     @user
  d.group     @group if @group
  d.mode      default?(@path) ? 00755 : 00700
  d.path      ::File.dirname(@path)
  d.recursive true
end

def create_file
  f = file @path
  f.owner   @user if @user
  f.group   @group if @group
  f.mode    default?(@path) ? 00644 : 00600
  f.content "# Created by Chef for #{node.name}\n\n#{to_config(@existing_entries)}"
end

def load_current_resource
  @user = new_resource.user || 'root'
  @group = new_resource.group || user_group(@user)
  @path = new_resource.path || default_or_user_path(new_resource.user)
  @existing_entries = parse_file @path

  @current_resource = Chef::Resource::SshConfig.new(@new_resource.name)
  @current_resource.exists = @existing_entries.key? @new_resource.name
end
