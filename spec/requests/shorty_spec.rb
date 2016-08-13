require 'rails_helper'

RSpec.describe 'Shorty', type: :request do
  describe 'POST /shorten' do
    it 'returns 400 response if url not present' do
      post '/shorten',
           params: {},
           headers: { 'ACCEPT' => 'application/json' },
           as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(400)
    end

    it 'returns 409 response if the the desired shortcode is already in use' do
      post '/shorten',
           params: { url: Faker::Internet.url, shortcode: 'aaaaaa' },
           headers: { 'ACCEPT' => 'application/json' },
           as: :json
      post '/shorten',
           params: { url: Faker::Internet.url, shortcode: 'aaaaaa' },
           headers: { 'ACCEPT' => 'application/json' },
           as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(409)
    end

    it 'returns 422 response if the shortcode fails to meet regexp: ^[0-9a-zA-Z_]{4,}$' do
      post '/shorten',
           params: { url: Faker::Internet.url, shortcode: 'abra-kadabra' },
           headers: { 'ACCEPT' => 'application/json' },
           as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(422)
    end

    it 'returns 201 response and random generated shortcode' do
      post '/shorten',
           params: { url: Faker::Internet.url },
           headers: { 'ACCEPT' => 'application/json' },
           as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(201)
      expect(json['shortcode']).to be
    end

    it 'returns 201 response and custom shortcode' do
      post '/shorten',
           params: { url: Faker::Internet.url, shortcode: 'aaaaaa' },
           headers: { 'ACCEPT' => 'application/json' },
           as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(201)
      expect(json['shortcode']).to eq('aaaaaa')
    end
  end

  describe 'GET /:shortcode' do
    it 'returns 404 response if the shortcode cannot be found in the system' do
      get '/aaaaaa',
          headers: { 'ACCEPT' => 'application/json' },
          as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(404)
    end

    it 'returns 302 response with the location header pointing to the shortened URL' do
      link = FactoryGirl.create(:link)
      get "/#{link.shortcode}",
          headers: { 'ACCEPT' => 'application/json' },
          as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(link.url)
    end
  end

  describe 'GET /:shortcode/stats' do
    it 'returns 404 response if the shortcode cannot be found in the system' do
      get '/aaaaaa/stats',
          headers: { 'ACCEPT' => 'application/json' },
          as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(404)
    end

    it 'returns 200 response with stats for link without redirects' do
      link = FactoryGirl.create(:link)
      get "/#{link.shortcode}/stats",
          headers: { 'ACCEPT' => 'application/json' },
          as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(200)
      expect(json['startDate']).to eq(link.created_at.as_json)
      expect(json['lastSeenDate']).not_to be
      expect(json['redirectCount']).to eq(0)
    end

    it 'returns 200 response with stats for link with redirects' do
      link = FactoryGirl.create(:link, :with_redirects)
      get "/#{link.shortcode}/stats",
          headers: { 'ACCEPT' => 'application/json' },
          as: :json
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(200)
      expect(json['startDate']).to eq(link.created_at.as_json)
      expect(json['lastSeenDate']).to eq(link.updated_at.as_json)
      expect(json['redirectCount']).to eq(link.redirects)
    end
  end
end
