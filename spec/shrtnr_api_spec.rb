require 'spec_helper'

describe Shortener do
  include Rack::Test::Methods

  def app
    Shortener
  end

  before(:all) do
    # Clear MongoDB before tests run
    @client = Mongo::Client.new(ENV['MONGODB_URI'])
    @db     = @client.database
    @coll   = @db[:shorts]
    @coll.drop
  end

  context 'POST /shorten' do
    it 'returns a 400 error if params not contain `url` attribute' do
      post '/shorten'

      expect(last_response.body).to include('url is not present')
      expect(last_response.status).to eq(400)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end

    it 'returns a 409 error if params contain shortcode from DB' do
      post '/shorten?url=http://example.com&shortcode=validcode'

      # Trying again same code
      post '/shorten?url=http://example.com&shortcode=validcode'

      expect(last_response.body).to include('The the desired shortcode is already in use.')
      expect(last_response.status).to eq(409)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end

    it 'returns a 422 error if shortcode not matching regex pattern' do
      post '/shorten?url=http://example.com&shortcode=&&&&^^^^^^^^^'

      expect(last_response.body).to include('The shortcode fails to meet the following regexp')
      expect(last_response.status).to eq(422)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end

    it 'creates record in DB and return shortcode back' do
      post '/shorten?url=http://example.com&shortcode=V3rYGo0d10'

      expect(last_response.body).to include('V3rYGo0d10')
      expect(last_response.status).to eq(201)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end
  end

  context 'GET /:code' do
    it 'returns a 404 error if code not found' do
      get '/614h614h'

      expect(last_response.body).to include('The shortcode cannot be found in the system')
      expect(last_response.status).to eq(404)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end

    it 'returns a location header along with 302 response code if valid `shortcode`' do
      post '/shorten?url=http://example.com&shortcode=V4l1dC0d3'

      get '/V4l1dC0d3'

      expect(last_response.status).to eq(302)
      expect(last_response.header['Location']).to eq('http://example.com')
    end
  end

  context 'GET /:code/stats' do
    it 'returns a 404 error if code not found' do
      get '/8Tr4n93/stats'

      expect(last_response.body).to include('The shortcode cannot be found in the system')
      expect(last_response.status).to eq(404)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end

    it 'returns stats if code is fine' do
      post '/shorten?url=http://example.com&shortcode=8Tr4n93'

      7.times { get '/8Tr4n93' }
      time = Time.now.utc.iso8601

      get '/8Tr4n93/stats'

      expect(JSON.parse(last_response.body)['redirectCount']).to eq(7)
      expect(JSON.parse(last_response.body)['lastSeenDate']).to eq(time)
      expect(last_response.status).to eq(200)
      expect(last_response.header['Content-Type']).to eq('application/json')
    end
  end

  context 'Testing Private code-generating method' do
    it 'should create valid code' do
      shortener_service = ShortcoderService.new
      code = shortener_service.send(:generate_code)
      expect(code.length).to eq(6)
      expect(code).to match(/^[0-9a-zA-Z_]{6}$/)
    end
  end
end
