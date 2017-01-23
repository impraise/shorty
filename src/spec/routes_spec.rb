require 'spec_helper'

RSpec.describe Routes do
  describe "POST shorten" do
    let(:shortcode) { nil }
    let(:url) { nil }
    let(:params) { {url: url, shortcode: shortcode} }
    context "url is not present" do
      it 'should respond with status 400 and body as "url is not present"' do
        post "/shorten"
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('url is not present')
      end
    end

    context "url is present" do
      context "url is empty" do
        let(:url) { '' }
        it 'should respond with status 400 and body as "url is not present"' do
          post "/shorten"
          expect(last_response.status).to eq(400)
          expect(last_response.body).to eq('url is not present')
        end
      end
      context "url is not empty" do
        let(:url) { 'http://cnn.com' }
        context "giving a shortcode" do
          context "and it doesn't follow regexp: ^[0-9a-zA-Z_]{4,}$" do
            let(:shortcode) { 'abc' }
            it 'should respond with body as "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$." and return status 422' do
              post "/shorten", params
              expect(last_response.body).to eq("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.")
              expect(last_response.status).to eq(409)
            end
          end
          context "and it is an inexistent shortcode" do
            let(:shortcode) { ShortcodeGenerator.random_shortcode }
            it 'should create a new ShortUrl' do
              expect {
                post "/shorten", params
              }.to change(ShortUrl,:count).by(1)
            end
            it 'should return the json object with the assigned shortcode and status 201' do
              post "/shorten", params
              expect(last_response.body).to eq({shortcode: shortcode}.to_json)
              expect(last_response.status).to eq(201)
            end
          end
          context "and it is an existent shortcode" do
            before :each do
              ShortUrl.create(url: url, shortcode: shortcode)
            end
            context "and the desired shortcode is in downcase of an existent one" do
              let(:shortcode) { ShortcodeGenerator.random_shortcode.upcase }
              let(:new_shortcode) { shortcode.downcase }
              let(:params) { {url: url, shortcode: new_shortcode} }
              it 'should return the json object with the assigned shortcode and status as 201' do
                post "/shorten", params
                expect(last_response.body).to eq({shortcode: new_shortcode}.to_json)
                expect(last_response.status).to eq(201)
              end
            end
            context "and the desired shortcode is equal an existent one" do
              let(:shortcode) { ShortcodeGenerator.random_shortcode }
              it 'should return the body as "The the desired shortcode is already in use. Shortcodes are case-sensitive." and status 422' do
                post "/shorten", params
                expect(last_response.body).to eq("The the desired shortcode is already in use. Shortcodes are case-sensitive.")
                expect(last_response.status).to eq(422)
              end
            end
          end
        end
        context "without shortcode" do
          it 'should create a new ShortUrl and return status 201' do
            expect {
              post "/shorten", params
            }.to change(ShortUrl,:count).by(1)
            expect(last_response.status).to eq(201)
          end
        end
      end
    end
  end

  describe "GET /:shorten" do
    context "with non existent ShortUrl" do
      it 'should respond body with "" and status 404' do
        get "/asdas"
        expect(last_response.body).to eq("The shortcode cannot be found in the system")
        expect(last_response.status).to eq(404)
      end
    end
    context "with existent ShortUrl" do
      let(:url) { 'http://existent.com'}
      let(:shortcode) {'shortcodetest01'}
      before :each do
        ShortUrl.create(url: url, shortcode: shortcode)
      end
      it 'should return a header with Location and status 302' do
        get "/#{shortcode}"
        header_with_location = {"Location" => url }
        expect(last_response.body).to eq('')
        expect(last_response.status).to eq(302)
        expect(last_response.header).to include(header_with_location)
      end
    end
  end
end
