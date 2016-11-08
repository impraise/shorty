require 'rails_helper'

RSpec.describe UrlController, type: :api do
 	describe 'POST /shorten' do
    it 'responds with a 201 with a valid url' do 
    	post '/shorten', { url: 'http://www.impraise.com/' }
    	expect(last_response.status).to eq 201
    end
    it 'responds with a valid shotcode with a valid url' do 
    	post '/shorten', { url: 'http://www.impraise.com/' }
    	expect(json["shortcode"]).to match(/\A[0-9a-zA-Z_]{4,}\z/)
    end
    it 'responds with a 400 when missing an url' do 
    	post '/shorten', { url: '' }
    	expect(last_response.status).to eq 400
    end
    it 'responds with a 409 with an already in use shortcode' do 
    	url = Url.create!(url: 'http://www.impraise.com/')
    	post '/shorten', { url: url.url, shortcode: url.shortcode } 
    	expect(last_response.status).to eq 409
    end
    it 'responds with a 422 with a shortcode in a not valid format' do 
    	post '/shorten', { url: 'http://www.impraise.com/', shortcode: '& not valid' } 
    	expect(last_response.status).to eq 422
    end
  end
  describe 'GET /:shorten' do
    it 'responds with a 302 with a valid shortcode' do 
    	url = Url.create!(url: 'http://www.impraise.com/')
    	get "/#{url.shortcode}"
    	expect(last_response.status).to eq 302
    end
    it 'responds with a 404 with a missing shortcode' do 
    	get "/missing"
    	expect(last_response.status).to eq 404
    end
  end
  describe 'GET /:shorten/stats' do
    it 'responds with accurate stats with a valid shortcode' do 
    	url = Url.new(url: 'http://www.impraise.com/')
    	15.times { url.visit! }
    	url.save!
    	get "/#{url.shortcode}/stats"
    	expect(last_response.status).to eq 200
    	expect(json["redirectCount"]).to eq 15
    	expect(Time.parse json["lastSeenDate"]).to be_within(1.second).of url.last_seen_at
    	expect(Time.parse json["startDate"]).to be_within(1.second).of url.created_at
    end
    it 'responds with a 404 with a missing shortcode' do 
    	get "/missing/stats"
    	expect(last_response.status).to eq 404
    end
  end
end
