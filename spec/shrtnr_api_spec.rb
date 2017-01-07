require 'spec_helper'

describe Shortener do
  include Rack::Test::Methods

  def app
    Shortener
  end

  #######   MOCK MONGA IN TESTS !!!!!   ###############

  context 'POST /shorten' do
    it 'returns a 400 error if params not contain `url` attribute' do
      post '/shorten'
      expect(last_response.body).to include('url is not present')
    end

    it 'returns a 422 error if shortcode not matching regex pattern' do
      post '/shorten?url=example.com&shortcode=&&&&^^^^^^^^^'
      expect(last_response.body).to include('The shortcode fails to meet the following regexp')
    end
  end
end
