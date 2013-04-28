module Grapcha
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
end
