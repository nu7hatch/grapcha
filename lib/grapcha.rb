require 'digest/md5'
require 'faraday'
require 'sinatra/base'
require 'securerandom'
require 'json'

require 'grapcha/version'
require 'grapcha/errors'
require 'grapcha/stores/in_memory/session_store'
require 'grapcha/stores/in_memory/gravatar_store'
require 'grapcha/gravatar'
require 'grapcha/services/captcha_creation_service'
require 'grapcha/services/captcha_validation_service'
require 'grapcha/api'

module Grapcha
  def self.session_store
    SessionMemoryStore
  end
end
