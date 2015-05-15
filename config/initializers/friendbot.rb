Friendbot.boot

unless Rails.configuration.cache_classes
  ActionDispatch::Reloader.to_cleanup do
    Friendbot.terminate
  end
end
