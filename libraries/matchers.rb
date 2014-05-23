# cookbook/libraries/matchers.rb

if defined?(ChefSpec)
  def add_ssh_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ssh_config, :add, resource_name)
  end

  def remove_ssh_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ssh_config, :remove, resource_name)
  end

  def add_ssh_known_hosts(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ssh_known_hosts, :add, resource_name)
  end

  def remove_ssh_known_hosts(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ssh_known_hosts, :remove, resource_name)
  end
end
