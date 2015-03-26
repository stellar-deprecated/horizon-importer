Rails.application.config.after_initialize do
  if ENV["FRIENDBOT_SECRET"].present?
    Friendbot.supervise_as :friendbot, ENV["FRIENDBOT_SECRET"]
    $friendbot = Celluloid::Actor[:friendbot]
  end
end