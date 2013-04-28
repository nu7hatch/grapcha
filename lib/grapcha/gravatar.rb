module Grapcha
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
end
