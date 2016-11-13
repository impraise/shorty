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
    before do
      get "/#{shortcode}"
    end

    context 'shortcode is not found' do
      before do
        expect(Shortcode.get(shortcode)).to be_nil
      end

      it 'should return 404 status' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'shortcode exists' do
      before do
        Shortcode.create(id: shortcode)
      end

      it 'should return 302 status' do
        expect(last_response.status).to eq(302)
      end

      it 'should redirect to the shortcode URL' do
        expect(last_response).to be_redirect
        expect(last_response.location).to eq(url)
      end
    end
  end

  describe 'GET /:shortcode/stats' do
    before do
      get "/#{shortcode}/stats"
    end

    context 'shortcode is not found' do
      before do
        expect(Shortcode.get(shortcode)).to be_nil
      end

      it 'should return 400 status' do
        expect(last_response.status).to eq(400)
      end
    end

    context 'shortcode exists' do
      let!(:existing_shortcode) do
        Shortcode.create(id: shortcode)
      end

      context 'shortcode has not been requested' do
        let(:expected_json) do
          {
            "startDate": existing_shortcode.created_at,
            "redirectCount": 0
          }
        end

        it 'should return the correct JSON' do
          expect(json_response).to eq(expected_json)
        end
      end

      context 'shortcode has been requested' do
        before do
          get "/#{shortcode}"
        end

        let(:expected_json) do
          {
            "startDate": existing_shortcode.created_at,
            "lastSeenDate": existing_shortcode.redirect_summary.updated_at,
            "redirectCount": 1
          }
        end

        it 'should return the correct JSON' do
          expect(json_response).to eq(expected_json)
        end
      end

      it 'should return 200 status' do
        expect(last_response.status).to eq(200)
      end
    end
  end
end
