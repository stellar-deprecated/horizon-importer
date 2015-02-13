require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module StellardHayashiApi
  class Application < Rails::Application

    config.generators do |g|
      g.orm             :active_record
      g.test_framework  :rspec, fixture: false
      g.template_engine :jbuilder
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

  end
end
