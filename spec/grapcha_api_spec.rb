require File.expand_path('../spec_helper', __FILE__)
require 'json'

describe Grapcha::API do
  let(:app) do
    Grapcha::API.new
  end

  let(:response_data) do
    JSON.parse(last_response.body)
  end

  describe "/new" do
    context "when no email given" do
      it "should return 400 with invalid email error" do
        get "/new?email="

        last_response.should_not be_ok
        last_response.status.should == 400

        response_data['error'].should == 'This is not a valid email address'
      end
    end

    context "when there's no gravatar for given email" do
      it "should return 400 with gravatar not found error" do
        get "/new?email=fake@veryfakemail.com"

        last_response.should_not be_ok
        last_response.status.should == 400

        response_data['error'].should == 'Gravatar not found for fake@veryfakemail.com'
      end
    end

    context "when email is correct and gravatar found" do
      it "should return list of gravatar hashes" do
        get "/new?email=chris@nu7hat.ch"

        last_response.should be_ok

        response_data.should be_kind_of(Array)
        response_data.should have(12).items
      end
    end
  end

  describe "/validate" do
    let(:email) do
      'chris@nu7hat.ch'
    end

    let(:valid_hash) do
      Gravatar.find(email).hash
    end

    context "when there was no captcha created" do
      it "should return 400 with invalid avatar chosen error" do
        get "/validate"
        get "/validate?avatar=#{valid_hash}"

        last_response.should_not be_ok
        last_response.status.should == 400

        response_data['error'].should == "Chosen avatar doesn't seem to be correct"
      end
    end

    context "when chosen avatar was invalid" do
      it "should return 400 with invalid avatar choosen error" do
        get "/new?email=#{email}"
        get "/validate?avatar=invalid"

        last_response.should_not be_ok
        last_response.status.should == 400

        response_data['error'].should == "Chosen avatar doesn't seem to be correct"
      end
    end

    context "when chosen avatar was correct" do
      it "should return 200 with success message" do
        get "/new?email=#{email}"
        get "/validate?avatar=#{valid_hash}"

        last_response.should be_ok

        response_data['success'].should == true
      end
    end
  end
end
