require "spec_helper"
require "./lib/models/encoded_link.rb"

describe EncodedLink do
  describe "validations" do
    context "when there is no shortcode" do
      it "is not valid" do
        link = build(:encoded_link, shortcode: nil)

        expect(link).not_to be_valid
        expect(link.errors["shortcode"]).to include("can't be blank")
      end
    end

    context "when there is no url" do
      it "is not valid" do
        link = build(:encoded_link, url: nil)

        expect(link).not_to be_valid
        expect(link.errors["url"]).to include("can't be blank")
      end
    end
  end
end
