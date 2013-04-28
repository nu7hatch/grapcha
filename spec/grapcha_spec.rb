require File.expand_path('../spec_helper', __FILE__)

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
