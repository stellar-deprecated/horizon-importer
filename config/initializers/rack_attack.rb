
unless ENV["NOTHROTTLE"] == "true" #TODO: move this into rails configuration

  Rack::Attack.throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip
  end

  Rack::Attack.throttle('test/always_throttle', :limit => 1, :period => 1.year) do |req|
    "1" if req.env["HTTP_X_ALWAYS_THROTTLE"] == "true";
  end

  THROTTLE_BODY = {
    type: "rate_limit_reached",
    title: "You have been rate limited.  Please try your request again later"
  }.to_json

  Rack::Attack.throttled_response = lambda do |env|
   [503, {}, [THROTTLE_BODY]]
  end

  BANNED_BODY = {
    type: "banned",
    title: "You are banned from using this API Server"
  }.to_json

  Rack::Attack.blacklisted_response = lambda do |env|
   [403, {}, [BANNED_BODY]]
  end

end