source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 4.0'
  gem 'rubocop'
end

group :unit do
  gem 'chefspec', '~> 4.1'
  gem 'berkshelf', '~> 3.1'
end

group 'integration' do
  gem 'kitchen-docker', '~> 1.5.0'
  gem 'kitchen-sync'
  gem 'kitchen-vagrant', '~> 0.11'
  gem 'minitest-chef-handler'
  gem 'test-kitchen', '~> 1.2'
  gem 'vagrant-wrapper'
end
