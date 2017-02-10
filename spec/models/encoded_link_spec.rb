require "spec_helper"
require "./lib/models/encoded_link.rb"

describe EncodedLink do
  describe "validations" do
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

    describe "shortcode format" do
      context "when the shortcode has invalid characters" do
        it "is invalid" do
          link = build(:encoded_link, shortcode: "123/56")

          expect(link).not_to be_valid
          expect(link.errors["shortcode"]).to include("is invalid")
        end
      end

      context "when the shortcode has invalid length" do
        it "is invalid" do
          link = build(:encoded_link, shortcode: "1234567")

          expect(link).not_to be_valid
          expect(link.errors["shortcode"]).to include("is invalid")
        end
      end

      context "when the shortcode matches the regex" do
        it "is valid" do
          link = build(:encoded_link, shortcode: "a2345z")

          expect(link).to be_valid
        end
      end
    end
  end

  describe "shortcode" do
    context "when the object already has a shortcode" do
      it "does not replace the existing shortcode" do
        encoded_link = build(:encoded_link, shortcode: "123456")
        encoded_link.save!
        expect(encoded_link.reload.shortcode).to eq("123456")
      end
    end

    context "when the object has no shortcode" do
      it "fills it with a generated shortcode" do
        encoded_link = build(:encoded_link, shortcode: nil)
        encoded_link.save!
        expect(encoded_link.reload.shortcode).not_to be_nil
      end
    end
  end
end
