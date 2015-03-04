# load all of our core extensions
Dir["#{Rails.root}/lib/core_ext/**/*.rb"].each { |f| require f }
