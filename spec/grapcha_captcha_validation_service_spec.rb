require File.expand_path('../spec_helper', __FILE__)

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
