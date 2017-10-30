require 'spec_helper'
require 'pry'

#TODO fix post json issue, refactor

describe 'ShortyApp' do
  include Rack::Test::Methods
  VALID_URL = 'http://ruisoares.github.io/'
  INVALID_URL = 'testing.shorty'

  def app
    Sinatra::Application
  end

  describe 'POST' do
    context 'without url' do
      it 'returns url is not present' do
        post '/shorten'
        expect(last_response.status).to eq 400
        #TODO expect response to be url is not present
      end
    end

    context 'with invalid url' do
      it 'returns invalid url' do
        params = {url: INVALID_URL}.to_json
        post '/shorten', JSON.parse(params), { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq 400
        #TODO expect response to be url is invalid
      end
    end

    context 'with valid url' do
      context 'without shortcode' do
        it 'returns a shortcode' do
          params = {url: VALID_URL}.to_json
          post '/shorten', JSON.parse(params), { 'CONTENT_TYPE' => 'application/json' }
          expect(last_response.status).to eq 201
          #TODO content-type must be application/json
          #TODO returns shortcode
        end
      end

      context 'with invalid shortcode' do
        it 'returns an invalid shortcode message' do
          params = {url: VALID_URL, shortcode: 'bad-_-'}.to_json
          post '/shorten', JSON.parse(params), { 'CONTENT_TYPE' => 'application/json' }
          expect(last_response.status).to eq 422
          #TODO expect response to be the invalid error
        end
      end

      context 'with duplicated shortcode' do
        it 'returns a duplicated shortcode message' do
          shortcode = 'repeat'
          Shorty.create(url: VALID_URL, shortcode: shortcode)
          params = {url: VALID_URL, shortcode: shortcode}.to_json
          post '/shorten', JSON.parse(params), { 'CONTENT_TYPE' => 'application/json' }
          expect(last_response.status).to eq 409
          #TODO expect response to be the duplicated error
        end
      end

      context 'with valid shortcode' do
        it 'returns the provided shortcode' do
          shortcode = 'Goood1'
          params = {url: VALID_URL, shortcode: shortcode}.to_json
          post '/shorten', JSON.parse(params), { 'CONTENT_TYPE' => 'application/json' }
          expect(last_response.status).to eq 201
          #TODO returns shortcode = shortcode
        end
      end
    end
  end

  describe 'GET' do
    context 'exists' do
      it 'redirects to the url' do
        Shorty.create(url: VALID_URL, shortcode: 'mysite')
        get '/mysite'
        expect(last_response.status).to eq 302
        # follow_redirect!
        # expect(last_request.path).to eq(VALID_URL)
        #TODO check location?
      end
    end

    context 'does not exist' do
      it 'returns not found' do
        get '/nonono'
        expect(last_response.status).to eq 404
        expect(last_response.body).to eq 'The shortcode cannot be found in the system'
      end
    end
  end

  describe 'GET stats' do
    context 'exists' do
      it 'returns the stats' do
        shorty = Shorty.create(url: VALID_URL, shortcode: '2stats')
        shorty.get_url
        stats = ShortySerializer.new(shorty).to_json
        get '/2stats/stats'
        expect(last_response.status).to eq 200
        expect(JSON.parse(last_response.body, symbolize_names: true)).to include stats
      end
    end

    context 'does not exist' do
      it 'returns not found' do
        get '/nonono/stats'
        expect(last_response.status).to eq 404
        expect(last_response.body).to eq 'The shortcode cannot be found in the system'
      end
    end
  end
end
