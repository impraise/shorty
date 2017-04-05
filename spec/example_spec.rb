require 'spec_helper'
require "rack/test"

describe Api::Example do
  include Rack::Test::Methods
  def app
    Api::Example
  end

  describe "GET /api/v1/urls/store" do
    it "returns an empty array of statuses" do
      get "/api/v1/urls/store"
      expect(last_response.status).to be 200
      expect(JSON.parse(last_response.body)['message']).to eq 200
    end
  end
end
