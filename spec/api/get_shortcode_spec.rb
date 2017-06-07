require 'spec_helper'

describe Shorty::GetShortcode do
  describe 'GET /:shortcode' do
    context 'with valid shortcode' do
      let(:shortcode) { 'foobar' }
      let(:url) { 'http://foo.bar' } 
      
      before { create_shortened_url(shortcode: shortcode, url: url) }
      
      it 'return status 302 Found' do
        get "/#{shortcode}"
        expect(last_response.status).to eq(302)
      end

      it 'return url on Location Header' do
        get "/#{shortcode}"
        location = last_response.headers['Location']
        
        expect(location).to eq(url)
      end
    end

    context 'with not found shortcode' do
      let(:shortcode) { 'foofoo' } 
    
      it 'return status 404 Not Found' do
        get "/#{shortcode}"
        expect(last_response.status).to eq(404)
      end

      it 'return the correct error message' do
        get "/#{shortcode}"
        parsed_body = JSON.parse(last_response.body)
        
        expect(
          parsed_body['error']
        ).to eq('The shortcode cannot be found in the system.')
      end
    end
  end
end