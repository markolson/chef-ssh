require 'chefspec'
require 'chefspec/berkshelf'
require 'rspec/mocks/message_expectation'

RSpec.configure do |config|
  config.color = true

  config.log_level = :error
end

ChefSpec::Coverage.start!

def recieve_foreach_and_yield(an_array)
  an_array.reduce(default_content(:array), :and_yield)
end
