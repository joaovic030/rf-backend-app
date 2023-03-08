source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"

gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem 'bcrypt', '~> 3.1.13'
gem "bootsnap", require: false

gem "graphql", "~> 1.12.12"
gem 'bunny', '~> 2.20', '>= 2.20.3'
gem 'sneakers', '~> 2.12'
gem 'rake', '~> 12.3'

group :development, :test do
  gem 'byebug', '~> 11.1', '>= 11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.19'
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.1'
end

group :development do
  gem 'rubocop', '~> 1.46', require: false
  gem 'rubocop-faker', '~> 1.1'
  gem 'rubocop-rails', '~> 2.18', require: false
  gem 'rubocop-rspec', '~> 2.18', '>= 2.18.1', require: false
end

group :test do
  gem 'simplecov', '~> 0.22.0'
  gem 'rspec-graphql_matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
