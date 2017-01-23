require 'spec_helper'

RSpec.describe ShortUrlService do
  describe "#shorten" do
    let(:url) { nil }
    let(:shortcode) { nil }
    let(:params) { { url: url, shortcode: shortcode} }
    context "without url" do
      it 'should raise ShortenException::UrlPresenceErrorException with message "url is not present"' do
        expect {
          ShortUrlService.shorten(params)
        }.to raise_error(ShortenException::UrlPresenceErrorException).with_message('url is not present')
      end
    end
    context "giving an empty url" do
      let(:url) { '' }
      it 'should raise ShortenException::UrlPresenceErrorException with message "url is not present"' do
        expect {
          ShortUrlService.shorten(params)
        }.to raise_error(ShortenException::UrlPresenceErrorException).with_message('url is not present')
      end
    end
    context "giving a valid url" do
      let(:url) { 'http://www.google.com' }
      context "with invalid shortcode" do
        context "giving less than 4 chars" do
          let(:shortcode) { 'abc' }
          it 'should raise ShortenException::ShortCodeFormatException with message "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."' do
            expect {
              ShortUrlService.shorten(params)
            }.to raise_error(ShortenException::ShortCodeFormatException).with_message('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
          end
        end
        context "giving more than 4 chars" do
          context "giving not alfanumeric chars" do
            let(:shortcode) { 'abc#' }
            it 'should raise ShortenException::ShortCodeFormatException with message "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."' do
              expect {
                ShortUrlService.shorten(params)
              }.to raise_error(ShortenException::ShortCodeFormatException).with_message('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
            end
          end
        end
      end
      context "with valid shortcode" do
        context "with existent shortcode" do
          let(:shortcode) { 'existent01' }
          before :each do
            ShortUrl.create(url:url, shortcode: shortcode)
          end
          it 'should raise ShortenException::ShortcodeAlreadyInUseException with message "The the desired shortcode is already in use. Shortcodes are case-sensitive."' do
            expect {
              ShortUrlService.shorten(params)
            }.to raise_error(ShortenException::ShortcodeAlreadyInUseException).with_message('The the desired shortcode is already in use. Shortcodes are case-sensitive.')
          end
        end
        context "with inexistent shortcode" do
          let(:shortcode) { 'inexistent02' }
          it 'should create a new ShortUrl' do
            expect {
              ShortUrlService.shorten(params)
            }.to change(ShortUrl,:count).by(1)
          end
        end
      end
      context "without shortcode" do
        it 'should have a call of generate_shortcode! from ShortUrl' do
          new_short_url = ShortUrl.new(params)
          spy(new_short_url)
          allow(ShortUrl).to receive(:new).with(params) { new_short_url }
          expect(new_short_url).to receive(:generate_shortcode!)
          ShortUrlService.shorten(params)
        end
        it 'should create a new ShortUrl' do
          expect {
            ShortUrlService.shorten(params)
          }.to change(ShortUrl,:count).by(1)
        end
      end
    end
  end

  describe "#get_with_increment" do
    let(:shortcode) { nil }
    context "with inexistent ShortUrl" do
      it 'should raise ShortenException::ShortUrlNotFoundException with message "The shortcode cannot be found in the system"' do
        expect {
          ShortUrlService.get_with_increment(shortcode)
        }.to raise_error(ShortenException::ShortUrlNotFoundException).with_message('The shortcode cannot be found in the system')
      end
    end
    context "with existent ShortUrl" do
      let(:url) { 'http://sample.com' }
      let(:shortcode) { 'newshorturl01' }
      before :each do
        @short_url = ShortUrl.create(url:url, shortcode: shortcode)
      end
      it 'should return the ShortUrl object' do
        expect(ShortUrlService.get_with_increment(shortcode)).to eq(@short_url)
      end
      it 'should receive call of increase_redirect_count!' do
        redirect_date = Time.now
        allow(ShortUrl).to receive(:get) { @short_url }
        expect(@short_url).to receive(:increase_redirect_count!)
        ShortUrlService.get_with_increment(shortcode)
      end
    end
  end
  describe "#get_as_json" do
    let(:shortcode) { nil }
    context "with inexistent ShortUrl" do
      it 'should raise ShortenException::ShortUrlNotFoundException with message "The shortcode cannot be found in the system"' do
        expect {
          ShortUrlService.get_as_json(shortcode)
        }.to raise_error(ShortenException::ShortUrlNotFoundException).with_message('The shortcode cannot be found in the system')
      end
    end
    context "with existent ShortUrl" do
      let(:url) { 'http://sample.com' }
      context "with redirect_count > 0" do
        let(:shortcode) { 'testexistentshorturlexample01' }
        before :each do
          @short_url = ShortUrl.create(url:url, shortcode: shortcode,redirect_count: 2, last_redirect_at: Time.now,created_at: Time.now)
        end
        it 'should return the ShortUrl object as Json' do
          short_url_as_json = {
            startDate: @short_url.created_at.to_time.utc.iso8601,
            redirectCount: @short_url.redirect_count,
            lastSeenDate: @short_url.last_redirect_at.to_time.utc.iso8601
          }
          expect(ShortUrlService.get_as_json(shortcode)).to eq(short_url_as_json)
        end
      end
      context "with redirect_count == 0" do
        let(:shortcode) { 'newshorturl01testcount' }
        before :each do
          @short_url = ShortUrl.create(url:url, shortcode: shortcode,created_at: Time.now)
        end
        it 'should return the ShortUrl object as Json' do
          short_url_as_json = {
            startDate: @short_url.created_at.to_time.utc.iso8601,
            redirectCount: @short_url.redirect_count,
          }
          expect(ShortUrlService.get_as_json(shortcode)).to eq(short_url_as_json)
        end
      end
    end
  end
end
