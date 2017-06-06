require 'spec_helper'

describe Shorty::PostShorten do
  describe 'POST /shorten' do
    context 'with valid shortcode' do
      let(:body) do
        { url: 'http://foo.bar', shortcode: 'foobar' }
      end
      
      it 'return status 201 Created' do
        post '/shorten', body
        expect(last_response.status).to eq(201)
      end
    end

    context 'with invalid shortcode' do
      let(:body) do
        { url: 'http://foo.bar', shortcode: 'foo$obar' }
      end
      
      it 'return status 422 Unprocessable Entity' do
        post '/shorten', body
        expect(last_response.status).to eq(422)
      end

      it 'return the correct error message' do
        post '/shorten', body
        parsed_body = JSON.parse(last_response.body)

        expect(
          parsed_body['error']
        ).to eq('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
      end
    end

    context 'with existing shortcode' do
      let(:body) do
        { url: 'http://foo.bar', shortcode: 'foobar' }
      end
      
      before { create_shortened_url(shortcode: body[:shortcode]) }

      it 'return status 409 Conflict' do
        post '/shorten', body
        expect(last_response.status).to eq(409)
      end

      it 'return the correct error message' do
        post '/shorten', body
        parsed_body = JSON.parse(last_response.body)
        
        expect(
          parsed_body['error']
        ).to eq('The desired shortcode is already in use. Shortcodes are case-sensitive.')
      end
    end

    context 'without url' do
      let(:body) do
        { shortcode: 'foobar' }
      end
      
      it 'return status 400 Bad Request' do
        post '/shorten', body

        expect(last_response.status).to eq(400)
      end

      it 'returns the correct error message' do
        post '/shorten', body
        parsed_body = JSON.parse(last_response.body)

        expect(
          parsed_body['error']
        ).to eq('url is missing')
      end
    end
  end
end