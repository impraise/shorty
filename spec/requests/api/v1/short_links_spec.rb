require 'spec_helper'
require 'rails_helper'

RSpec.describe 'Shorty api', type: :request do

  let!(:short_link) { create(:short_link) }
  let(:short_link_id) { short_link.id }
  let(:shortcode) { short_link.shortcode }

  describe 'POST /shorten' do
    context 'creates new short link' do

      it 'returns 402 invalid format' do
        post '/api/v1/shorten', short_link: { url: "http://example.com/", shortcode: "1234567" }
        expect(response.code).to eq '422'
        expect(JSON.parse(response.body)['errors']).to eq('shortcode has invalid format')
      end

      it 'returns 409 already in use' do
        post '/api/v1/shorten', short_link: { url: "http://example.com/", shortcode: shortcode }
        expect(response.code).to eq '409'
        expect(JSON.parse(response.body)['errors']).to eq('shortcode already in use')
      end
    end
  end


  # test for GET request on /:shortcode
  describe 'GET /api/v1/fetch_short_code/:shortcode' do
    before { get "/api/v1/fetch_short_code/#{shortcode}", params: shortcode }

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
