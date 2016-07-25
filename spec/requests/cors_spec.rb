require 'rails_helper'

describe 'CORS', type: :request do
  it 'returns headers' do
    headers = { 'HTTP_ORIGIN' => 'http://corsexample.com',
                'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => 'Content-Type',
                'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET' }

    get '/shorten', params: {}, headers: headers

    expect(response.headers['Access-Control-Allow-Origin']).to  eq('http://corsexample.com')
    expect(response.headers['Access-Control-Allow-Methods']).to eq('CREATE, SHOW, STATS')
  end
end
