require 'rack/test'

describe 'API' do
  include Rack::Test::Methods

  def app
    API
  end

  describe 'POST /shorten' do
    context 'url is not present'
    context 'shortcode is not present'
    context 'desired shortcode is already in use'
    context 'shortcode fails to meet the regexp'

    it 'should return 201 status'
    it 'should return the shortcode as JSON'
  end

  describe 'GET /:shortcode' do
    context 'shortcode is not found'

    it 'should return 302 status'
    it 'should redirect to the shortcode URL'
  end

  describe 'GET /:shortcode/stats' do
    context 'shortcode is not found'
    context 'shortcode has not been requested'

    it 'should return 200 status'
    it 'should return the stats as JSON'
  end
end
