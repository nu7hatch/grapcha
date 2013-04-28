module Grapcha
  class Error < StandardError
    def to_json
      { error: to_s }.to_json
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
      super "This is not a valid email address"
    end
  end

  class InvalidAvatarChosen < Error
    def initialize
      super "Chosen avatar doesn't seem to be correct"
    end
  end
end
