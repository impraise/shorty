require 'spec_helper'

describe RetrieveShortenedUrlService do
  describe '#perform' do
    context 'with valid shortcode' do
      let(:shortcode) { 'foobar' }

      before { create_shortened_url(shortcode: shortcode) }

      it 'update url stats' do
        service = RetrieveShortenedUrlService.new(shortcode)
        
        first_access = service.perform
        first_redirect = first_access.redirect_count
        first_last_seen = first_access.last_seen_date

        second_access = service.perform
        second_redirect = second_access.redirect_count
        second_last_seen = second_access.last_seen_date
        
        expect(second_redirect).to be > first_redirect
        expect(second_last_seen).to be > first_last_seen
      end

      it 'return shortened url' do
        service = RetrieveShortenedUrlService.new(shortcode)
        
        shortened_url = service.perform

        expect(shortened_url.shortcode).to eql(shortcode)
      end
    end

    context 'with invalid shortcode' do
      let(:shortcode) { 'foofoo' }

      it 'raise NotFoundShortcodeError error' do
        service = RetrieveShortenedUrlService.new(shortcode)

        expect {
          service.perform
        }.to raise_error(Shorty::Errors::NotFoundShortcodeError)
      end
    end
  end
end