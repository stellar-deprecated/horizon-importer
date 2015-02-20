source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'torquebox-web', ">= 4.0.0.alpha1"
gem 'aasm', '~> 4.0.8'
gem 'metriks', '~> 0.9.9.7'
gem 'xdr', git: "git@github.com:stellar/ruby-xdr"
gem 'stellar-core', git: "git@github.com:stellar/ruby-stellar-core.git"
gem 'faraday'
gem 'composite_primary_keys', '~> 7.0.13'

# sql gems
gem 'pg', platform: :ruby
gem 'sqlite3', platform: :ruby

gem 'jdbc-postgres', platform: :jruby
gem 'jdbc-sqlite3', platform: :jruby
gem 'activerecord-jdbc-adapter', platform: :jruby


group :test, :development do
  gem 'dotenv-rails', github: "bkeepers/dotenv"
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'shoulda-matchers'
  gem 'guard'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end
