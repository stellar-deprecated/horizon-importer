
def setup_friendbot
  if ENV["FRIENDBOT_SECRET"].present?
    Friendbot.supervise_as :friendbot, ENV["FRIENDBOT_SECRET"]
    $friendbot = Celluloid::Actor[:friendbot]
  end
end

if Rails.configuration.cache_classes
  setup_friendbot
else
  ActionDispatch::Reloader.to_prepare do
    setup_friendbot
  end

  ActionDispatch::Reloader.to_cleanup do
    $friendbot.terminate if $friendbot
  end
end