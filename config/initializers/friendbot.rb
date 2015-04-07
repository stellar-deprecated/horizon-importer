
puts "in friendbot initializer"

if Rails.configuration.cache_classes
  Friendbot.boot
else
  ActionDispatch::Reloader.to_prepare do
    Friendbot.boot
  end

  ActionDispatch::Reloader.to_cleanup do
    Friendbot.terminate
  end
end