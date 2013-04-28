require 'rspec'
require 'grapcha'
require 'rack/test'

include Grapcha

Dir[File.expand_path('../support/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
  include Rack::Test::Methods
end
