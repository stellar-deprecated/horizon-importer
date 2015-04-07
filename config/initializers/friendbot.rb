class FriendbotRailtie < ::Rails::Railtie
  config.to_prepare do
    Friendbot.boot
  end
end

unless Rails.configuration.cache_classes
  ActionDispatch::Reloader.to_cleanup do
    Friendbot.terminate
  end
end