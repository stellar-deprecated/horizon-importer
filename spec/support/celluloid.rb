require 'celluloid/test'

RSpec.configure do |c|
  c.around(:example) do |example|
    Celluloid.boot
    begin
      example.run
    ensure
      Celluloid.shutdown
    end
  end
end

