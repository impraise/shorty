require 'rails_helper'

describe ShortenUrlController, type: :controller do
  describe 'POST #create' do
    it 'returns http :success' do
      post :create, params: { url: 'http://example.com', shortcode: 'example' }

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json')
    end

    it 'returns shortcode in format json' do
      post :create, params: { url: 'http://example.com', shortcode: 'example' }
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:shortcode)
      expect(data[:shortcode]).to eq('example')
    end

    it 'must generate the shortcode when it is not given' do
      post :create, params: { url: 'http://example.com' }
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:shortcode)
      expect(data[:shortcode]).to match(/\A[0-9a-zA-Z_]{6}\z/)
    end

    it 'returns http :bad_request for invalid url' do
      post :create, params: { url: 'http//example' }

      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to eq('application/json')
    end

    it 'returns http :unprocessable_entity for invalid shortcode' do
      post :create, params: { url: 'http://example.com', shortcode: 'short-code$' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end

    it 'returns http :conflict for duplicated shortcode' do
      create(:url_address, shortcode: 'batman')
      post :create, params: { url: 'http://example.com', shortcode: 'batman' }

      expect(response).to have_http_status(:conflict)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'GET #show' do
    let(:url_address) { create(:url_address, shortcode: 'superman') }

    it 'returns http :found' do
      get :show, params: { shortcode: url_address.shortcode }

      expect(response).to have_http_status(:found)
      expect(response.content_type).to eq('application/json')
    end

    it 'redirects to the properly URL given from shortcode' do
      get :show, params: { shortcode: url_address.shortcode }

      expect(response.content_type).to eq('application/json')
      expect(subject).to redirect_to(url_address.url)
    end

    it 'must increase the redirect_count' do
      expect(url_address.redirect_count).to eq(0)

      get :show, params: { shortcode: url_address.shortcode }

      expect(url_address.reload.redirect_count).to eq(1)
    end

    it 'returns http :not_found when passes an invalid shortcode' do
      get :show, params: { shortcode: 'inexistent-shortcode' }

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'GET #stats' do
    let(:url_address) { create(:url_address, shortcode: 'superman') }
    let(:serialized_url) { UrlAddressSerializer.new(url_address) }
    let(:serialized_data) { JSON.parse(serialized_url.to_json, symbolize_names: true) }

    it 'returns http :ok with UrlAddress info' do
      get :stats, params: { shortcode: url_address.shortcode }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
      expect(data).to eq(serialized_data)
      expect(data).to_not have_key(:lastSeenDate)
    end

    it 'returns UrlAddress info with redirect info' do
      url_address.register_access!

      get :stats, params: { shortcode: url_address.shortcode }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
      expect(data).to eq(serialized_data)
      expect(data[:redirectCount]).to eq(1)
    end

    it 'returns http :not_found with an invalid shortcode' do
      get :stats, params: { shortcode: 'inexistent-shortcode' }

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq('application/json')
    end
  end
end
