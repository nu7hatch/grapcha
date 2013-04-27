require 'grapcha/version'
require 'digest/md5'
require 'faraday'
require 'sinatra/base'
require 'securerandom'
require 'json'

module Grapcha
  def self.session_store
    SessionMemoryStore
  end

  class Error < StandardError
    def to_json
      { error: to_s }.to_json
    end
  end

  module GravatarMemoryStore
    def self.included(base)
      base.extend(ClassMethods)
    end

    def save
      self.class.storage[self.hash] = true
    end

    module ClassMethods
      def storage
        @storage ||= {}
      end

      def random(limit, insert)
        result = [ insert ]
        hashes = storage.keys.dup

        hashes.delete(insert)

        while limit > 1
          hash = hashes.delete_at(rand(hashes.size))
          result << hash
          limit -= 1
        end

        result
      end
    end
  end

  class Gravatar
    def self.service_url
      "http://gravatar.com"
    end

    def self.http
      Faraday.new(service_url) do |f|
        f.request :url_encoded
        f.adapter :net_http
      end
    end

    def self.hash(email)
      Digest::MD5.hexdigest(email)
    end

    def self.find(email)
      hashed   = hash(email)
      path     = "/avatar/#{hashed}.jpg"
      response = http.head(path) { |req| req.params[:d] = '404' }

      return if response.status != 200

      new(hashed)
    end

    include GravatarMemoryStore

    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end
  end

  class SessionMemoryStore
    def storage
      @storage ||= {}
    end

    def id
      @id ||= SecureRandom.hex
    end

    def mark(hash)
      storage[id] = hash
    end

    def valid?(hash)
      storage.delete(id) == hash
    end
  end

  class GravatarNotFound < Error
    attr_reader :email

    def initialize(email)
      @email = email
      super "Gravatar not found for #{email}"
    end
  end

  class InvalidEmailGiven < Error
    def initialize
      super "This is not valid email address"
    end
  end

  class CaptchaCreationService
    attr_reader :email

    def initialize(email)
      @email = email
    end

    def gravatar
      @gravatar ||= Gravatar.find(email)
    end

    def call(session)
      raise InvalidEmailGiven if email.to_s.empty?
      raise GravatarNotFound, email unless gravatar

      gravatar.save
      session.mark(gravatar.hash)

      response = Gravatar.random(12, gravatar.hash)
      response.shuffle
    end
  end

  class InvalidAvatarChosen < Error
    def initialize
      super "Chosen avatar doesn't seem to be correct"
    end
  end

  class CaptchaValidationService
    def self.call(session, hash)
      raise InvalidAvatarChosen unless session.valid?(hash)

      { success: true }
    end
  end

  class API < Sinatra::Application
    set :cache, SessionMemoryStore.new

    before do
      content_type 'application/json'
    end

    get "/new" do
      begin
        service = CaptchaCreationService.new(params[:email])
        service.call(settings.cache).to_json
      rescue GravatarNotFound, InvalidEmailGiven => err
        status 400
        err.to_json
      end
    end

    get "/validate" do
      begin
        result = CaptchaValidationService.call(settings.cache, params[:avatar])
        result.to_json
      rescue InvalidAvatarChosen => err
        status 400
        err.to_json
      end
    end
  end
end
