module Grapcha
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
