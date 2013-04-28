module Grapcha
  class CaptchaValidationService
    def self.call(session, hash)
      raise InvalidAvatarChosen unless session.valid?(hash)

      { success: true }
    end
  end
end
