actions :add, :remove # TODO: add replace action (or add if missing??)
default_action :add

attribute :host, :kind_of => String, :name_attribute => true
attribute :port, :kind_of => Integer, :default => 22
attribute :hashed, :kind_of => [TrueClass, FalseClass], :default => TrueClass
attribute :key, :kind_of => String
attribute :user, :kind_of => String
attribute :group, :kind_of => String
attribute :path, :kind_of => String

attr_accessor :exists
alias_method  :exists?, :exists
