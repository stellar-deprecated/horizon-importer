RSpec.configure do |c| 
  c.before(:example) do
    Rails.cache.clear
  end
end

