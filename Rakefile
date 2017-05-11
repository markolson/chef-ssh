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
      :fail_tags => %w[any],
      :tags => %w[~FC001]
    }
  end
end

desc 'Run all style checks'
task :lint => %w[lint:chef lint:ruby]

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
desc 'Run Test Kitchen'
task :integration, [:mode] do |_, args|
  args.with_defaults(:mode => :always)
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

# Default
task :default => %w[test]

desc 'Run only the fastest tests (lint and spec tests)'
task :fast => %w[lint spec]

desc 'Run everything we have'
task :test => %w[fast integration]
