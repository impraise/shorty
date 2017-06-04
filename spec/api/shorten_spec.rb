require 'spec_helper'

describe Shorty::Shorten do
  context 'GET /shorten' do
    it 'returns success' do
      get '/shorten'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to include('success' => true)
    end
  end
end