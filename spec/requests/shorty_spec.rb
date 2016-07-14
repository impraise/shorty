require 'rails_helper'

RSpec.describe 'Shorty', type: :request do
  describe 'POST /shorten' do
    it 'returns 400 response if url not present'
    it 'returns 409 response if the the desired shortcode is already in use'
    it 'returns 422 response if the shortcode fails to meet regexp: ^[0-9a-zA-Z_]{4,}$'
    it 'returns 201 response and random generated shortcode'
    it 'returns 201 response and custom shortcode'
  end

  describe 'GET /:shortcode' do
    it 'returns 404 response if the shortcode cannot be found in the system'
    it 'returns 302 response with the location header pointing to the shortened URL'
  end

  describe 'GET /:shortcode/stats' do
    it 'returns 404 response if the shortcode cannot be found in the system'
    it 'returns 200 response with stats'
  end
end
