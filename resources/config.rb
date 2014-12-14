actions :add, :add_if_missing, :remove
default_action :add

attribute :host,    :kind_of => String, :name_attribute => true
attribute :options, :kind_of => Hash
attribute :user,    :kind_of => String
attribute :group,   :kind_of => String
attribute :path,    :kind_of => String

attr_accessor :exists
alias_method  :exists?, :exists
