require "spec_helper.rb"

describe "the sinatra app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def post_as_json(path, params)
    post path, params.to_json, "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"
  end

  describe "POST /shorten" do
    context "when no JSON is provided" do
      it "returns 400" do
        post "/shorten"
        expect(last_response.status).to eq(400)
      end
    end

    context "when invalid JSON is provided" do
      it "returns 400" do
        post "/shorten", "onetwo", "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(400)
      end
    end

    context "when no url is provided" do
      it "returns 400" do
        post_as_json("/shorten", foo: "bar")
        expect(last_response.status).to eq(400)
      end
    end

    context "when only the url is provided" do
      it "returns 201 and JSON" do
        post_as_json("/shorten", url: "shorty.com")
        expect(last_response.status).to eq(201)
        expect(JSON.parse(last_response.body)["shortcode"]).not_to be_nil
      end
    end

    context "when both url and shortcode are provided" do
      context "when the shortcode has an invalid format" do
        it "returns 422" do
          post_as_json("/shorten", url: "shorty.com", shortcode: "asd")
          expect(last_response.status).to eq(422)
        end
      end

      context "when the shortcode has already been taken" do
        let(:existing_link) { create(:encoded_link) }
        it "returns 409" do
          post_as_json("/shorten", url: "shorty.com", shortcode: existing_link.shortcode)
          expect(last_response.status).to eq(409)
        end
      end

      context "when the shortcode has a valid format and hasn't been taken" do
        it "returns 201 and JSON" do
          post_as_json("/shorten", url: "shorty.com", shortcode: "123456")
          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)["shortcode"]).to eq("123456")
        end
      end
    end
  end

  describe "GET /:shortcode" do
    context "when the shortcode doesn't correspond to any encoded link" do
      it "returns 404" do
        get "/foobar"
        expect(last_response.status).to eq(404)
      end
    end

    context "when the shortcode corresponds to the encoded link" do
      let(:encoded_link) { create(:encoded_link) }

      it "returns 302 with the corresponding url" do
        get "/#{encoded_link.shortcode}"
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_request.url).to eq(encoded_link.url)
      end

      it "creates a LinkAccess" do
        expect(encoded_link.link_accesses.count).to eq(0)
        get "/#{encoded_link.shortcode}"
        expect(encoded_link.link_accesses.count).to eq(1)
      end
    end
  end
end
