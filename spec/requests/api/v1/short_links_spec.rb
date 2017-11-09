require 'spec_helper'
require 'rails_helper'
require 'support/shared_factories'

RSpec.describe 'ShortLinks', type: :request do
  include_context 'shared factories'

  describe 'POST /shorten' do
    context 'tries to create a new short_link' do
      it 'returns 400 missing parameter' do
        post '/api/v1/shorten', params: { url: "", shortcode: shortcode }
        expect(response.code).to eq '400'
        expect(JSON.parse(response.body)['errors']).to include("can't be blank")
      end

      it 'returns 402 invalid format' do
        post '/api/v1/shorten', params: { url: "http://example.com/", shortcode: "1234567" }
        expect(response.code).to eq '422'
        expect(JSON.parse(response.body)['errors']).to include('is invalid')
      end

      it 'returns 409 already in use' do
        post '/api/v1/shorten', params: { url: "http://example.com/", shortcode: shortcode }
        expect(response.code).to eq '409'
        expect(JSON.parse(response.body)['errors']).to include('been taken')
      end

      it 'returns 201 created' do
        post '/api/v1/shorten', params: { url: "http://example.com/", shortcode: '123456' }
        expect(response.code).to eq '201'
        expect(JSON.parse(response.body)['shortcode']).to eq('123456')
      end
    end
  end

  describe 'GET /api/v1/fetch_short_code/:shortcode' do
    before { get "/api/v1/fetch_short_code/#{shortcode}" }

    context 'when shortcode exists' do
      it 'returns the shortcode' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['shortcode']).to eq(shortcode)
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end
  end
end
