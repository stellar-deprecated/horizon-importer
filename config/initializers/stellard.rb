base_url = Rails.application.config.stellard_url

$stellard = Faraday.new(url: base_url) do |conn|
  conn.response :logger, Rails.logger  
  conn.request :url_encoded
  conn.response :json
  conn.adapter Faraday.default_adapter
end

# NOTE: regarding thread safety.  According to the faraday issues, it should be 
# threadsafe, and for now we will assume it is.  Prior to launch we should either
# confirm or deny this, and change this global accordingly