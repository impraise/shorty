require 'spec_helper'

RSpec.describe UrlShortcode do

  describe "shortcode validations" do
    context "without url" do
      it "should not be valid" do
        url_shortcode = UrlShortcode.new(shortcode: "shortcode", url: nil)

        expect(url_shortcode.valid?).to be_falsey
      end
    end

    context "validate shortcode uniqueness" do
      context "when shortcode already exists" do
        before { UrlShortcode.create(shortcode: "google", url: "google.com") }

        it "should not persist the shortcode" do
          url_shortcode = UrlShortcode.new(shortcode: "google", url: "google.com")

          expect { url_shortcode.save }.to_not change(UrlShortcode, :count)
        end
      end
    end

    context "validates format of shortcode to match /^[0-9a-zA-Z_]{4,}$/" do
      context "shortcode with length less than 4" do
        it 'should not be valid' do
          url_shortcode = UrlShortcode.new(shortcode: "cod", url: "google.com")

          expect(url_shortcode.valid?).to be_falsey
        end
      end

      context "shortcode has invalid characters" do
        it 'should not be valid' do
          url_shortcode = UrlShortcode.new(shortcode: "abcsd/=+_", url: "google.com")

          expect(url_shortcode.valid?).to be_falsey
        end
      end

      context "shortcode has invalid characters" do
        it 'should be valid' do
          url_shortcode = UrlShortcode.new(shortcode: "abcd1234_", url: "google.com")

          expect(url_shortcode.valid?).to be_truthy
        end
      end
    end
  end

  describe "shortcode creation" do
    context "when shortcode provided" do
      it "should create the url_shortcode entry with the given shortcode" do
        url_shortcode = UrlShortcode.new(shortcode: "GoOgLe_", url: "google.com")
        url_shortcode.save

        expect(url_shortcode.shortcode).to eq("GoOgLe_")
      end
    end

    context "when shortcode not provided" do
      it "should create a new shortcode" do
        url_shortcode = UrlShortcode.new(url: "google.com")
        url_shortcode.save

        expect(url_shortcode.shortcode).to_not be_nil
      end
    end
  end

  describe "#update_redirect_count" do
    let(:shortcode) { UrlShortcode.create(url: "http://google.com") }

    it 'should increment the redirect counter' do
      expect {
        shortcode.update_redirect_count
      }.to change { shortcode.redirect_count }.from(0).to(1)
    end

    it 'should change updated_at' do
      shortcode.update(last_visited_at: DateTime.now)

      expect {
        shortcode.update_redirect_count
      }.to change { shortcode.last_visited_at }
    end
  end
end
