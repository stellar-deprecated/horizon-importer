source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'aasm', '~> 4.0.8'
gem 'metriks', '~> 0.9.9.7'
gem 'xdr', git: "git@github.com:stellar/ruby-xdr"
# gem 'xdr', path: "../ruby-xdr", require: false
gem 'stellar-core', git: "git@github.com:stellar/ruby-stellar-core.git", require: false
# gem 'stellar-core', path: "../ruby-stellar-core", require: false
gem 'faraday'
gem 'faraday_middleware'
gem 'composite_primary_keys', '~> 7.0.13'
gem 'memoist'
gem 'backports'
gem 'json_expressions'
gem 'rack-attack'
gem 'oat'
gem 'low_card_tables'

# note: the following celluloid and sucker_punch gems are require: false
# so that the rspec system can bootup the system manually.  
# See config/initializers/celluloid.rb for where we include these files in
# non-test scenarios
gem 'celluloid', require: false
gem 'sucker_punch', require: false

# sql gems
gem 'pg', platform: :ruby
gem 'sqlite3', platform: :ruby

gem 'jdbc-postgres', platform: :jruby
gem 'jdbc-sqlite3', platform: :jruby
gem 'activerecord-jdbc-adapter', platform: :jruby

#memcached
gem 'memcached', platform: :ruby, require: 'memcached'
gem 'jruby-memcached', platform: :jruby, require: 'memcached'

#webservers
gem 'puma', platform: :ruby
gem 'torquebox-web', ">= 4.0.0.alpha1", platform: :jruby


group :test, :development do
  gem 'dotenv-rails', github: "bkeepers/dotenv"
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'shoulda-matchers'
  gem 'guard'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'yard'
end
