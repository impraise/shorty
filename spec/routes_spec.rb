require "json"

RSpec.describe Shorty do

  describe 'POST /shorten' do
    context "when no params are provided" do

      context 'no params in request body' do
        let(:params) { nil }

        it 'should return 400 status' do
          post "/shorten", params

          expect(last_response.status).to eq(400)
          expect(JSON.parse(last_response.body)["error"]).to eq("Invalid Data")
        end
      end

      context 'paramters missing' do
        let(:params) { {}.to_json }

        it 'should return 400 status' do
          post "/shorten", params

          expect(last_response.status).to eq(400)
          expect(JSON.parse(last_response.body)["error"]).to eq("'url' is not present")
        end
      end

      context 'url paramter missing' do
        let(:params) { { shortcode: "someshort" }.to_json }

        it 'should return 400 status' do
          post "/shorten", params

          expect(last_response.status).to eq(400)
          expect(JSON.parse(last_response.body)["error"]).to eq("'url' is not present")
        end
      end
    end

    context "when url and shortcode is provided" do

      context "when only url is provided" do
        let(:params) { { url: "google.com" }.to_json }

        it "returns 201 status" do
          post "/shorten", params

          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)["shortcode"]).to eq(UrlShortcode.last.shortcode)
        end
      end

      context "when desired shortcode is present in params" do
        let(:params) { { url: "google.com", shortcode: "GoGLe_" }.to_json }

        it "returns 201 status with the provided shortcode" do
          expect { post "/shorten", params }.to change(UrlShortcode, :count).by(1)
          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)["shortcode"]).to eq("GoGLe_")
        end
      end

      context "when provided shortcode is already in use" do
        before { UrlShortcode.create(url: "google.com", shortcode: "GoGLe_") }

        let(:params) { { url: "google.com", shortcode: "GoGLe_" }.to_json }

        it "returns status 409 with appropriate message" do
          post "/shorten", params

          expect(last_response.status).to eq(409)
          expect(JSON.parse(last_response.body)["error"]).to eq("The the desired shortcode is already in use. Shortcodes are case-sensitive.")
        end
      end

      context "when provided shortcode is not of correct format" do
        let(:params) { { url: "google.com", shortcode: "GoGLe-CM=" }.to_json }

        it "returns status 422 with appropriate message" do
          post "/shorten", params

          expect(last_response.status).to eq(422)
          expect(JSON.parse(last_response.body)["error"]).to eq("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.")
        end
      end

    end
  end
end
