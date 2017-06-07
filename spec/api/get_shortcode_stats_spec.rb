require 'spec_helper'

describe Shorty::GetShortcodeStats do
  describe 'GET /:shortcode/stats' do
    context 'with valid shortcode' do
      let(:shortcode) { 'foobar' }
      let(:url) { 'http://foo.bar' } 
      let!(:shortenerd_url) { create_shortened_url(shortcode: shortcode, url: url) }
      
      it 'return status 200 OK' do
        get "/#{shortcode}/stats"
        expect(last_response.status).to eq(200)
      end

      context 'when shortcode have already been accessed' do
        before do 
          RetrieveShortenedUrlService.new(shortenerd_url.shortcode).perform
        end

        it 'return full stats on body' do
          get "/#{shortcode}/stats"
          parsed_body = JSON.parse(last_response.body)
          
          expect(parsed_body).to include('startDate', 'redirectCount', 'lastSeenDate')
        end
      end

      context 'when shortcode have never been accessed' do
        it 'return stats without lastSeenDate on body' do
          get "/#{shortcode}/stats"
          parsed_body = JSON.parse(last_response.body)

          expect(parsed_body).to include('startDate', 'redirectCount')
          expect(parsed_body).not_to include('lastSeenDate')
        end
      end
    end

    context 'with not found shortcode' do
      let(:shortcode) { 'foofoo' } 
    
      it 'return status 404 Not Found' do
        get "/#{shortcode}/stats"
        expect(last_response.status).to eq(404)
      end

      it 'return the correct error message' do
        get "/#{shortcode}/stats"
        parsed_body = JSON.parse(last_response.body)
        
        expect(
          parsed_body['error']
        ).to eq('The shortcode cannot be found in the system.')
      end
    end
  end
end