actions :create
default_action :create

attribute :host, :kind_of => String, :name_attribute => true
attribute :hashed, :kind_of => [TrueClass, FalseClass], :default => TrueClass
attribute :key, :kind_of => String
attribute :user, :kind_of => String
attribute :path, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
