require 'rspec'
require 'grapcha'

include Grapcha

Dir[File.expand_path('../support/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
end
