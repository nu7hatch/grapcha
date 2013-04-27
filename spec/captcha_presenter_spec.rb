require File.expand_path('../spec_helper', __FILE__)
require 'digest/md5'

describe Grapcha do
  describe "session store" do
    let(:session) do
      Grapcha.session_store.new
    end

    it "should be able to store and validate hashes" do
      session.mark("test")
      session.should be_valid("test")
    end

    it "should invalidate non wront hashes" do
      session.should_not be_valid("fake")
    end

    it "should have random id" do
      session.id.should be
    end
  end
end

describe Gravatar do
  let(:gravatar) do
    Gravatar.new("hash")
  end

  it "should be initialized with avatar hash" do
    gravatar.hash.should == "hash"
  end

  describe ".service_url" do
    it "should return url of the gravatar service" do
      Gravatar.service_url.should == "http://gravatar.com"
    end
  end

  describe ".find" do
    let(:gravatar) do
      Gravatar.find(email)
    end

    context "when given user doesn't have gravatar" do
      let(:email) do
        "fake@veryfakemail.com"
      end

      it "should return nil" do
        gravatar.should_not be
      end
    end

    context "when given user has gravatar" do
      let(:email) do
        "chris@nu7hat.ch"
      end

      let(:digest) do
        Digest::MD5.hexdigest(email)
      end

      it "should return it's record" do
        gravatar.should be_kind_of(Gravatar)
      end
    end
  end
end

describe CaptchaCreationService do
  let(:service) do
    CaptchaCreationService.new(email)
  end

  let(:email) do
    'chris@nu7hat.ch'
  end

  it "should be initialized with email" do
    service.email.should == email
  end

  describe "#call" do
    context "when given email has no gravatar" do
      let(:email) do
        'fake@veryfakemail.com'
      end

      it "should raise an error" do
        expect {
          service.call(nil)
        }.to raise_error(GravatarNotFound, "Gravatar not found for #{email}")
      end
    end

    context "when invalid email given" do
      let(:email) do
        nil
      end

      it "should raise an error" do
        expect {
          service.call(nil)
        }.to raise_error(InvalidEmailGiven)
      end
    end

    context "when given email has gravar" do
      let(:session) do
        Grapcha.session_store.new
      end

      let(:response) do
        service.call(session)
      end

      before do
        20.times do |i|
          Gravatar.new("test#{i}").save
        end
      end

      before do
        session.should_receive(:mark).with(service.gravatar.hash)
        service.gravatar.should_receive(:save)
        response
      end

      it "should save the session" do
        # checked in before filter
      end

      it "should store that gravatar" do
        # checked in before filter
      end

      it "should return list of gravatars to compare" do
        response.compact.should have(12).items
        response.should include(service.gravatar.hash)
      end
    end
  end
end

describe CaptchaValidationService do
  let(:service) do
    CaptchaValidationService
  end

  let(:generator) do
    CaptchaCreationService.new(email)
  end

  let(:email) do
    'chris@nu7hat.ch'
  end

  let(:session) do
    Grapcha.session_store.new
  end

  before do
    generator.call(session)
  end

  describe ".call" do
    context "when chosen avatar is not correct" do
      it "should raise an error" do
        expect {
          service.call(session, "wrong")
        }.to raise_error(InvalidAvatarChosen)
      end
    end

    context "when chosen avatar is ok" do
      it "should return hash with success result" do
        session.should_receive(:valid?).with("good").and_return(true)
        service.call(session, "good").should == { success: true }
      end
    end
  end
end
