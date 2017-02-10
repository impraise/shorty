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

    context "when an EncodedLink already exists" do
      let(:existing_link) { create(:encoded_link) }

      it "does not allow creating another with the same shortcode" do
        new_link = build(:encoded_link, shortcode: existing_link.shortcode)

        expect(new_link).not_to be_valid
        expect(new_link.errors["shortcode"]).to include("has already been taken")
      end
    end
  end
end
