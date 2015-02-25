
unless ENV["NOCOVERAGE"] = "true" 
  require 'simplecov'
  SimpleCov.start 'rails'
end