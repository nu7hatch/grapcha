require File.expand_path('../spec_helper', __FILE__)

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
