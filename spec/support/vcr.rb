require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  record_mode = RERECORD ? :all : :none
  c.default_cassette_options = { :record => record_mode }
end