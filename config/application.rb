require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module StellardHayashiApi
  class Application < Rails::Application

    # custom configs

    config.stellard_url = ENV["STELLARD_URL"]
    raise "STELLARD_URL environment variable unset" if config.stellard_url.blank?
    #


    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/errors"

    config.generators do |g|
      g.orm             :active_record
      g.test_framework  :rspec, fixture: false, views: false
      g.template_engine :jbuilder
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

  end
end
