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
    let(:url_shortcode) { UrlShortcode.create(url: "http://google.com") }

    it 'should increment the redirect counter' do
      expect {
        url_shortcode.update_redirect_count
      }.to change { url_shortcode.reload.redirect_count }.from(0).to(1)
    end

    it 'should change updated_at' do
      expect {
        url_shortcode.update_redirect_count
      }.to change { url_shortcode.reload.last_visited_at }
    end
  end

  describe "#stats" do
    context "when new shortcode is created and never visited" do
      let(:url_shortcode) { UrlShortcode.create(url: "http://google.com") }

      it "should return stats hash without lastSeenDate" do
        expected = {
          startDate: url_shortcode.start_date,
          redirectCount: url_shortcode.redirect_count
        }

        expect(url_shortcode.stats).to eq(expected)
        expect(url_shortcode.stats).to_not have_key(:lastSeenDate)
      end
    end

    context "when shortcode exists and has already been visited" do
      let(:url_shortcode) { UrlShortcode.create(url: "http://google.com") }

      it "should return stats hash with lastSeenDate" do
        url_shortcode.update_redirect_count

        expected = {
          startDate: url_shortcode.start_date,
          redirectCount: url_shortcode.redirect_count,
          lastSeenDate: url_shortcode.last_visited_date
        }

        expect(url_shortcode.stats).to eq(expected)
        expect(url_shortcode.stats).to have_key(:lastSeenDate)
      end
    end
  end

  describe "#start_date" do
    let(:url_shortcode) { UrlShortcode.create(url: "http://google.com") }

    it "returns shortcode creation date conforming to 'iso8601' format" do
      expect(url_shortcode.start_date).to eq(url_shortcode.created_at.to_time.utc.iso8601(3))
    end
  end

  describe "#last_visited_date" do
    let(:url_shortcode) { UrlShortcode.create(url: "http://google.com") }

    context "when redirect count is 0" do
      it "does not return short code last visit date" do
        expect(url_shortcode.last_visited_date).to be_nil
      end
    end

    context "when redirect count is more than 0" do
      before do
        5.times { url_shortcode.reload; url_shortcode.update_redirect_count }
      end

      it "returns shortcode last visit date conforming to 'iso8601' format" do
        expect(url_shortcode.last_visited_date).to eq(url_shortcode.last_visited_at.to_time.utc.iso8601(3))
      end
    end
  end

end
