require 'spec_helper'
require 'pry'
require 'json'

#TODO refactor

describe 'ShortyApp' do
  include Rack::Test::Methods
  VALID_URL = 'http://ruisoares.github.io/'
  INVALID_URL = 'testing.shorty'

  def app
    Sinatra::Application
  end

  describe 'POST' do
    before do
      headers = {'CONTENT_TYPE' => 'application/json'}
    end

    context 'without url' do
      it 'returns url is not present' do
        post '/shorten', {}.to_json
        expect(last_response.status).to eq 400
        expect(last_response.body).to eq 'url is not present'
      end
    end

    context 'with invalid url' do
      it 'returns invalid url' do
        body = { url: INVALID_URL }
        post '/shorten', body.to_json
        expect(last_response.status).to eq 400
        expect(last_response.body).to eq 'invalid url'
      end
    end

    context 'with valid url' do
      context 'without shortcode' do
        it 'returns a 6 characters long valid shortcode' do
          body = {url: VALID_URL}
          post '/shorten', body.to_json
          expect(last_response.status).to eq 201
          expect(last_response.header["Content-type"]).to eq "application/json"
          expect(JSON.parse(last_response.body)["shortcode"]).to match(/^[0-9a-zA-Z_]{6}$/)
        end
      end

      context 'with invalid shortcode' do
        it 'returns an invalid shortcode message' do
          body = {url: VALID_URL, shortcode: 'bad-_-'}
          post '/shorten', body.to_json
          expect(last_response.status).to eq 422
          expect(last_response.body).to eq 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{6}$.'
        end
      end

      context 'with duplicated shortcode' do
        it 'returns a duplicated shortcode message' do
          shortcode = 'repeat'
          Shorty.create(url: VALID_URL, shortcode: shortcode)
          body = {url: VALID_URL, shortcode: shortcode}
          post '/shorten', body.to_json
          expect(last_response.status).to eq 409
          expect(last_response.body).to eq 'The desired shortcode is already in use. Shortcodes are case-sensitive.'
        end
      end

      context 'with valid shortcode' do
        it 'returns the provided shortcode' do
          shortcode = 'Goood1'
          body = {url: VALID_URL, shortcode: shortcode}
          post '/shorten', body.to_json
          expect(last_response.status).to eq 201
          expect(last_response.header["Content-type"]).to eq "application/json"
          expect(JSON.parse(last_response.body)["shortcode"]).to eq shortcode
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
        expect(last_response.header["Location"]).to eq VALID_URL
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
