require File.expand_path '../spec_helper.rb', __FILE__

describe "Shorty Application" do
  it "should allow accessing the root page" do
    get '/'
    expect(last_response).to be_ok
  end

  describe "GET /:shortcode" do
    before do
      post '/shorten', {shortcode: 'sample', url: 'http://sample.com'}
    end

    subject { get '/sample' }

    it "returns 302" do
      subject
      expect(last_response.status).to eq(302)
    end

    it "redirects to url acording to the shortcode" do
      subject
      expect(last_response.location).to eq('http://sample.com')
    end

    context "with failure" do
      context "when shortcode not found" do
        subject { get '/sample2' }

        it "returns status code 404" do
          subject
          expect(last_response.status).to eq(404)
        end

        it "returns message" do
          subject
          expect(JSON.parse(last_response.body)["message"]).to eq("The shortcode cannot be found in the system")
        end
      end
    end
  end

  describe "POST /shorten" do
    before(:all) do
      post '/shorten', {shortcode: 'example', url: 'http://example.com'}
    end

    it "returns 201" do
      expect(last_response.status).to eq(201)
    end

    it "returns content-type application/json" do
      expect(last_response.content_type).to eq("application/json;charset=utf-8")
    end

    it "returns json with shortcode" do
      expect(last_response.body).to eq({shortcode: 'example'}.to_json)
    end

    context "when no shortcode is provided" do
      before(:all) do
        post '/shorten', {url: 'http://example2.com'}
      end

      it "returns json with auto generated shortcode that is not null" do
        expect(JSON.parse(last_response.body)['shortcode']).to_not be_nil
      end

      it "returns json with auto generated shortcode" do
        expect(JSON.parse(last_response.body)['shortcode']).to match(/^[0-9a-zA-Z_]{4,}$/)
      end
    end

    context "with failure" do
      context "when url is not present" do
        before(:all) { post '/shorten' }

        it "returns status code 400" do
          expect(last_response.status).to eq(400)
        end

        it "returns message" do
          expect(JSON.parse(last_response.body)["message"]).to eq("'url' is not present")
        end
      end

      context "when shortcode is already in use" do
        before(:all) do
          post '/shorten', {shortcode: 'example', url: 'http://another-example.com'}
        end

        it "returns status code 409" do
          expect(last_response.status).to eq(409)
        end

        it "returns message" do
          expect(JSON.parse(last_response.body)["message"]).to eq("The the desired shortcode is already in use. Shortcodes are case-sensitive.")
        end
      end

      context "when shortcode fails to meet the pattern" do
        before(:all) do
          post '/shorten', {shortcode: '!@#$%', url: 'http://example.com'}
        end

        it "returns status code 422" do
          expect(last_response.status).to eq(422)
        end

        it "returns message" do
          expect(JSON.parse(last_response.body)["message"]).to eq("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.")
        end
      end
    end
  end

  describe "GET /:shortcode/stats" do
    before do
      post '/shorten', {shortcode: 'another', url: 'http://another.com'}
      get '/another/stats'
    end

    it "returns 200" do
      expect(last_response.status).to eq(200)
    end

    it "redirects to url acording to the shortcode" do
      expect(JSON.parse(last_response.body)["startDate"]).to_not be_nil
      expect(JSON.parse(last_response.body)["lastSeenDate"]).to_not be_nil
      expect(JSON.parse(last_response.body)["redirectCount"]).to eq(0)
    end

    context "when accessing shortned url" do

      subject do
        get '/another'
        get '/another/stats'
      end

      it "increases the redirectCount" do
        expect{ subject }.to change{JSON.parse(last_response.body)["redirectCount"]}.by(1)
      end
    end

    context "with failure" do
      context "when shortcode not found" do
        subject { get '/sample2/stats' }

        it "returns status code 404" do
          subject
          expect(last_response.status).to eq(404)
        end

        it "returns message" do
          subject
          expect(JSON.parse(last_response.body)["message"]).to eq("The shortcode cannot be found in the system")
        end
      end
    end
  end
end
