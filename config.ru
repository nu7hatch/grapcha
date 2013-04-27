$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'grapcha'
run Grapcha::API.new
