require 'rails_helper'

RSpec.describe "Shorts", type: :request do

  describe "POST /shorten" do
    it "creates a short and returns a shortcode" do
      post "/shorten", {url: "http://example.com"}, {}
      parsed_json = JSON.parse(response.body)
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:created)
      expect(parsed_json["shortcode"]).to be_truthy
    end
  end

  describe "GET /:shortcode" do
    it "redirects to the short url" do
      short = Short.create(url: "http://example.com")
      get "/#{short.shortcode}"
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(short.url)
    end
  end

  describe "GET /:shortcode/stats" do
    it "returns the short stats" do
      short = Short.create(url: "http://example.com")
      get "/#{short.shortcode}/stats"
      parsed_json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(parsed_json.keys).to include("startDate", "lastSeenDate", "redirectCount")
    end
  end

end
