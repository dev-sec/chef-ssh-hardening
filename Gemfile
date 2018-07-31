# encoding: utf-8

source 'https://rubygems.org'

gem 'berkshelf', '~> 7.0'
gem 'chef', '~> 14.3'

group :test do
  gem 'chefspec', '~> 7.2'
  gem 'coveralls', require: false
  gem 'foodcritic', '~> 14.0'
  gem 'rake'
  gem 'rubocop', '~> 0.49.0'
  gem 'simplecov', '~> 0.10'
end

group :development do
  gem 'guard'
  gem 'guard-foodcritic', '~> 3.0'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end

group :integration do
  gem 'kitchen-dokken'
  gem 'kitchen-inspec', '>= 0.23.1'
  gem 'kitchen-vagrant'
  gem 'test-kitchen', '~> 1.20'
end

group :tools do
  gem 'github_changelog_generator', '~> 1.14'
end
