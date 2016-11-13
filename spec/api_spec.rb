require 'rack/test'
require 'json'

describe 'API' do
  include Rack::Test::Methods

  def app; API; end
  def json_response
    JSON.parse(last_response.body) rescue {}
  end

  let(:shortcode) { 'asdf1234' }
  let(:url) { 'http://www.impraise.com' }
  let(:params) do
    { "shortcode": shortcode, "url": url }
  end

  describe 'POST /shorten' do
    before do
      post '/shorten', params
    end

    context 'url param is not present' do
      let!(:params) do
        { "shortcode": shortcode }
      end

      it 'should return 400 status' do
        expect(last_response.status).to eq(400)
      end
    end

    context 'desired shortcode is already in use' do
      before do
        Shortcode.create(id: shortcode)
      end

      it 'should return 409 status' do
        expect(last_response.status).to eq(409)
      end
    end

    context 'shortcode fails to meet the documented regexp' do
      let!(:shortcode) { 'bad :(' }

      it 'should return 422 status' do
        expect(last_response.status).to eq(422)
      end
    end

    it 'should return 201 status'do
      expect(last_response.status).to eq(201)
    end

    it 'should return the shortcode as JSON' do
      expect(json_response['shortcode']).to eq(shortcode)
    end
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
