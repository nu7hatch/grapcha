require File.expand_path('../spec_helper', __FILE__)
require 'digest/md5'

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
