require 'rails_helper'

RSpec.describe ShortsController, type: :controller do

  let(:valid_url) { "http://example.com" }
  let(:valid_shortcode) { "valid1" }

  let(:valid_params) {
    {
      url: valid_url
    }
  }

  let(:valid_session) { {} }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Short" do
        expect {
          post :create, valid_params, session: valid_session
        }.to change(Short, :count).by(1)
      end

      it "assigns a newly created short as @short" do
        post :create, valid_params, session: valid_session
        expect(assigns(:short)).to be_a(Short)
        expect(assigns(:short)).to be_persisted
      end

      it "returns the created short" do
        post :create, valid_params.merge({shortcode: valid_shortcode}), session: valid_session
        parsed_json = JSON.parse(response.body)
        expect(parsed_json["shortcode"]).to eq(valid_shortcode)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved short as @short" do
        post :create, {}, session: valid_session
        expect(assigns(:short)).to be_a_new(Short)
      end

      it "returns an error" do
        post :create, {}, session: valid_session
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to include({"url"=>["url is not present"]})
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested short as @short" do
      short = Short.create!({url: valid_url})
      get :show, shortcode: short.shortcode, session: valid_session
      expect(assigns(:short)).to eq(short)
    end

    context "when shortcode is valid" do
      it "redirects to the short url" do
        short = Short.create!({url: valid_url})
        get :show, shortcode: short.shortcode, session: valid_session
        expect(response).to redirect_to short.url
      end
    end

    context "when shortcode is not valid" do
      it "returns an error" do
        get :show, shortcode: "invalid", session: valid_session
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to include({"shortcode"=>"The shortcode cannot be found in the system"})
      end
    end
  end

  describe "GET #stats" do
    it "assigns the requested short as @short" do
      short = Short.create({url: valid_url})
      get :stats, shortcode: short.shortcode, session: valid_session
      expect(assigns(:short)).to eq(short)
    end

    context "when shortcode is valid" do
      it "returns the short stats" do
        short = Short.create({url: valid_url})
        get :stats, shortcode: short.shortcode, session: valid_session
        parsed_json = JSON.parse(response.body)
        expect(parsed_json["startDate"]).to be_truthy
        expect(parsed_json["lastSeenDate"]).to be_truthy
        expect(parsed_json["redirectCount"]).to be_truthy
      end
    end

    context "when shortcode is not valid" do
      it "returns an error" do
        get :show, shortcode: "invalid", session: valid_session
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to include({"shortcode"=>"The shortcode cannot be found in the system"})
      end
    end
  end


end
