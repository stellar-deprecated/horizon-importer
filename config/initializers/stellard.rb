base_url = Rails.application.config.stellard_url

$stellard = Faraday.new(url: base_url) do |conn|
  conn.response :logger, Rails.logger  
  conn.request :url_encoded
  conn.adapter Faraday.default_adapter
end