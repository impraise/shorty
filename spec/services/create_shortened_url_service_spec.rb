require 'spec_helper'

describe CreateShortenedUrlService do
  describe '#perform' do
    context 'with valid shortcode' do
      let(:url_params) do
        { url: 'http://foo.bar', shortcode: 'foobar' }
      end

      it 'creates a shortened url with the given shortcode' do
        service = CreateShortenedUrlService.new(url_params)
        
        shortened_url = service.perform
        
        expect(shortened_url.shortcode).to eql(url_params[:shortcode])
      end
    end

    context 'with existing shortcode' do
      let(:url_params) do
        { url: 'http://foo.bar', shortcode: 'foobar' }
      end

      before { create_shortened_url(shortcode: url_params[:shortcode]) }

      it 'raise ExistingShortcodeError error' do
        service = CreateShortenedUrlService.new(url_params)

        expect {
          service.perform
        }.to raise_error(Shorty::Errors::ExistingShortcodeError)
      end
    end

    context 'with invalid format shortcode' do
      let(:url_params) do
        { url: 'http://foo.bar', shortcode: 'foo-bar' }
      end

      it 'raise InvalidShortcodeError error' do
        service = CreateShortenedUrlService.new(url_params)

        expect {
          service.perform
        }.to raise_error(Shorty::Errors::InvalidShortcodeError)
      end
    end

    context 'with case-sensitivity difference' do
      let(:url_params) do
        { url: 'http://foo.bar', shortcode: 'foobar' }
      end

      before { create_shortened_url(shortcode: url_params[:shortcode].capitalize) }

      it 'creates the shortened url normally' do
        service = CreateShortenedUrlService.new(url_params)

        shortened_url = service.perform
        
        expect(shortened_url.shortcode).to eql(url_params[:shortcode])
      end
    end
    
    context 'without shortcode' do
      let(:url_params) do
        { url: 'http://foo.bar' }
      end
      subject { CreateShortenedUrlService.new(url_params) }
      it 'creates a shortened url with a random shortcode' do
        shortened_url = subject.perform
        
        expect(shortened_url.shortcode).not_to be_nil
      end

      it 'shortcode matches /^[0-9a-zA-Z_]{6}$/' do
        shortened_url = subject.perform
        
        expect(shortened_url.shortcode).to match(/^[0-9a-zA-Z_]{6}$/)
      end
    end
  end
end