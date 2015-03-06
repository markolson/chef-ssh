require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

# lint tests. Rubocop and Foodcritic
namespace :lint do
  desc 'Run Ruby lint checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef lint checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      :fail_tags => %w(any)
    }
  end
end

desc 'Run all style checks'
task :lint => %w(lint:chef lint:ruby)

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
desc 'Run Test Kitchen'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

# Default
task :default => %w(all)

desc 'Run only the reasonably fast tests (lint, spec, and fast kitchen tests'
task :fast => %w(lint spec)

desc 'Run everything we have'
task :all => %w(lint spec integration)
