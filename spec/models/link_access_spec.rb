require "spec_helper"
require "./lib/models/link_access.rb"

describe LinkAccess do
  describe "validations" do
    context "when the encoded_liink is missing" do
      it "is not valid" do
        link_access = described_class.new(encoded_link: nil)
        expect(link_access).not_to be_valid
        expect(link_access.errors["encoded_link"]).to include("can't be blank")
      end
    end
  end
end
