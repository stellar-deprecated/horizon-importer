require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module StellardHayashiApi
  class Application < Rails::Application

    # custom configs

    config.stellard_url = ENV["STELLARD_URL"] || "http://localhost:39132"

    #


    config.autoload_paths += ["#{config.root}/lib"]

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
