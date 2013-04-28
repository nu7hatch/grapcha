require 'webmock'

include WebMock::API

stub_request(:head, "gravatar.com/avatar/#{Gravatar.hash("chris@nu7hat.ch")}.jpg")
  .with(:query => hash_including({'d' => '404'}))
  .to_return(:status => 200)

stub_request(:head, "gravatar.com/avatar/#{Gravatar.hash("fake@veryfakemail.com")}.jpg")
  .with(:query => hash_including({'d' => '404'}))
  .to_return(:status => 404)
