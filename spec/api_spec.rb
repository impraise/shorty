require 'rack/test'

describe 'API' do
  include Rack::Test::Methods

  def app
    API
  end

  describe 'POST /shorten' do
    context 'url param is not present' do
      it 'should return 400 status'
    end

    context 'desired shortcode is already in use' do
      it 'should return 409 status'
    end

    context 'shortcode fails to meet the regexp' do
      it 'should return 422 status'
    end

    it 'should return 201 status'
    it 'should return the shortcode as JSON'
  end

  describe 'GET /:shortcode' do
    context 'shortcode is not found' do
      it 'should return 404 status'
    end

    it 'should return 302 status'
    it 'should redirect to the shortcode URL'
  end

  describe 'GET /:shortcode/stats' do
    context 'shortcode is not found' do
      it 'should return 400 status'
    end

    context 'shortcode has not been requested'

    it 'should return 200 status'
    it 'should return the stats as JSON'
  end
end
