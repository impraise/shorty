require 'rails_helper'

RSpec.describe 'ShortenUrls', type: :request do
  include JsonResponse

  describe 'shorten flow' do
    let(:url) { 'http://example.com' }

    it 'creates a short url' do
      post '/shorten', params: { url: url }, as: :json
      expect(response).to have_http_status(201)

      code = json_response[:shortcode]
      expect(code).to match(/\A[0-9a-zA-Z_]*\z/)

      get "/#{code}/stats", as: :json
      expect(response).to have_http_status(200)

      redirect_count = json_response[:redirectCount]
      expect(redirect_count).to eq 0

      get "/#{code}", as: :json
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(url)

      get "/#{code}/stats", as: :json
      expect(response).to have_http_status(200)

      redirect_count = json_response[:redirectCount]
      expect(redirect_count).to eq 1
    end
  end
end
