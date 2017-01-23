require 'spec_helper'

RSpec.describe ShortUrl do
  let(:short_url) { ShortUrl.new({:shortcode => shortcode, url: url }) }
  let(:shortcode) { nil }
  let(:url) { nil }

  context "shortcode validations" do
    let(:url) { 'http://www.validurl.com' }
    context "validate uniqueness of shortcode" do
      context "with existent shortcode" do
        let(:shortcode) { 'short0102' }
        let(:short_url2) { ShortUrl.new({:shortcode => shortcode, url: url }) }
        before :each do
          short_url.save
        end
        it 'should not create a new ShortUrl with same shortcode' do
          expect(short_url2.valid?).to be_falsey
        end
        it 'should have errors on shortcode' do
          short_url2.valid?
          expect(short_url2.errors).to include(["Shortcode is already taken"])
        end
      end
    end
    context "without shortcode" do
      it 'should not be valid' do
        expect(short_url.valid?).to be_falsey
      end
      it 'should have errors on shortcode' do
        short_url.valid?
        expect(short_url.errors).to include(["Shortcode must not be blank"])
      end
    end
    context "validate format of with /^[0-9a-zA-Z_]{4,}$/" do
      context "with invalid shortcode" do
        context "giving less than 4 chars" do
          let(:shortcode) { 'abc' }
          it 'should be false' do
            expect(short_url.valid?).to be_falsey
          end
        end
        context "giving more than 4 chars" do
          context "giving not alfanumeric chars" do
            let(:shortcode) { 'abc#' }
            it 'should be false' do
              expect(short_url.valid?).to be_falsey
            end
          end
          context "giving alfanumeric chars and _" do
            let(:shortcode) { 'abcd123_' }
            it 'should be false' do
              expect(short_url.valid?).to be_truthy
            end
          end
        end
      end
    end
  end

  context "url validations" do
    let(:shortcode) { 'validshortcode123' }
    context "without url" do
      it 'should not be valid' do
        short_url.valid?
        expect(short_url.valid?).to be_falsey
      end
      it 'should have errors on url' do
        short_url.valid?
        expect(short_url.errors).to include(["Url must not be blank"])
      end
    end
    context "with url" do
      let(:url) { 'http://validurl.com' }
      it 'should be valid' do
        expect(short_url.valid?).to be_truthy
      end
    end
  end
  context "#generate_shortcode!" do
    it 'expect to set shortcode' do
      short_url = ShortUrl.new
      allow(ShortcodeGenerator).to receive(:random_shortcode) { "vv22xB" }
      expect {
        short_url.generate_shortcode!
      }.to change(short_url,:shortcode).from(nil).to("vv22xB")
    end
  end
  context "#increase_redirect_count!" do
    it 'should increase redirect_count on each call' do
      short_url = ShortUrl.new
      expect{
        short_url.increase_redirect_count!
      }.to change(short_url,:redirect_count).from(0).to(1)
      expect{
        short_url.increase_redirect_count!
      }.to change(short_url, :redirect_count).from(1).to(2)
    end
    it 'should set last_redirect_at' do
      short_url = ShortUrl.new
      short_url.increase_redirect_count!
      expect(short_url.last_redirect_at).to_not be_nil
      expect(short_url.last_redirect_at).to be_a(DateTime)
    end
  end
end
