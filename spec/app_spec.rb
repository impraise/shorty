require File.expand_path '../spec_helper.rb', __FILE__

describe "Shorty Application" do
  it "should allow accessing the root page" do
    get '/'
    expect(last_response).to be_ok
  end

  describe "GET /:shortcode" do
    it "redirects to url acording to the shortcode" do
      post '/shorten', {shortcode: 'example', url: 'http://example.com'}
      get '/example'
      expect(last_response.location).to eq('http://example.com')
    end
  end

  describe "POST /short" do
    it "returns json with shortcode" do
      post '/shorten', {shortcode: 'example', url: 'http://exaple.com'}
      expect(last_response.body).to eq({shortcode: 'example'}.to_json)
    end
  end
end
