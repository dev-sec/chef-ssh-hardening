# encoding: utf-8

# rubocop:disable Style/SymbolArray

require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'chef/cookbook/metadata'

# General tasks

# Rubocop before rspec so we don't lint vendored cookbooks
desc 'Run all tests except Kitchen (default task)'
task default: [:lint, :spec]

# Lint the cookbook
desc 'Run all linters: rubocop and foodcritic'
task lint: [:rubocop, :foodcritic]

# Run the whole shebang
desc 'Run all tests'
task test: [:lint, :integration, :spec]

# RSpec
desc 'Run chefspec tests'
task :spec do
  puts 'Running Chefspec tests'
  RSpec::Core::RakeTask.new(:spec)
end

# Foodcritic
desc 'Run foodcritic lint checks'
task :foodcritic do
  puts 'Running Foodcritic tests...'
  FoodCritic::Rake::LintTask.new do |t|
    t.options = { fail_tags: ['any'] }
    puts 'done.'
  end
end

# Rubocop
desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

# Automatically generate a changelog for this project. Only loaded if
# the necessary gem is installed.
begin
  # read version from metadata
  metadata = Chef::Cookbook::Metadata.new
  metadata.instance_eval(File.read('metadata.rb'))

  # build changelog
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = "v#{metadata.version}"
    config.user = 'dev-sec'
    config.project = 'chef-ssh-hardening'
    config.exclude_labels = ['no changelog', 'question', 'duplicate', 'wontfix', 'invalid']
  end
rescue LoadError
  puts '>>>>> GitHub Changelog Generator not loaded, omitting tasks'
end

desc 'Run kitchen integration tests'
task :kitchen do
  concurrency = ENV['CONCURRENCY'] || 1
  instance = ENV['INSTANCE'] || ''
  args = ENV['CI'] ? '--destroy=always' : ''
  sh('sh', '-c', "bundle exec kitchen test -c #{concurrency} #{args} #{instance}")
end
