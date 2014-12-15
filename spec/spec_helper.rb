require 'chefspec'
require 'chefspec/berkshelf'
require 'rspec/mocks/message_expectation'

RSpec.configure do |config|
  config.color = true

  config.log_level = :error
end

ChefSpec::Coverage.start!
