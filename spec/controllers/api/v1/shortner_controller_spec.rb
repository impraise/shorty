require 'rails_helper'

RSpec.describe Api::V1::ShortnerController do
  include JsonResponse

  let(:url) { 'http://example.com' }
  let(:code) { 'somecode' }

  describe '#create' do
    context 'URL provided' do
      it 'creates a record' do
        expect { post :create, params: { url: url } }.to change(Link, :count).by(1)
      end

      it 'returns the new shortcode' do
        post :create, params: { url: url }

        expect(json_response).to match(shortcode: anything)
      end

      it 'returns 201 status code' do
        post :create, params: { url: url }

        expect(response.status).to eq 201
      end

      it 'returns 400 if the url not valid' do
        post :create, params: { url: 'invalid' }

        expect(response.status).to eq 400
      end
    end

    context 'URL no provided' do
      it 'returns 400 error' do
        post :create, params: {}

        expect(response.status).to eq 400
      end
    end

    context 'shortcode provided' do
      it 'assigned to the new record' do
        post :create, params: { url: url, shortcode: 'somecode' }

        expect(Link).to be_exist(code: 'somecode')
      end

      it 'returns 409 error when shortcode not uniq' do
        Link.create!(url: 'http://other.com', code: 'somecode')

        post :create, params: { url: url, shortcode: 'somecode' }

        expect(response.status).to eq 409
      end

      it 'returns 422 error when shortcode not in the proper format' do
        post :create, params: { url: url, shortcode: '!somecode' }

        expect(response.status).to eq 422
      end
    end
  end

  describe '#show' do
    context 'Link with shortcode exist' do
      let!(:link) { Link.create!(url: url, code: code) }

      it "redirect to link's url" do
        get :show, params: { shortcode: 'somecode' }

        expect(response.status).to eq 302
        expect(response).to redirect_to('http://example.com')
      end

      it 'updates stats' do
        expect_any_instance_of(LinkStatService).to receive(:link_showed!)
          .with(instance_of(Link))

        get :show, params: { shortcode: 'somecode' }
      end
    end

    context 'There no link with given shortcode' do
      subject { get :show, params: { shortcode: 'realynotexistcode' } }

      it { is_expected.to have_http_status(404) }
    end
  end

  describe '#stats' do
    render_views # because we using jbuilder

    context 'link record exists and was visited before' do
      let!(:link) { Link.create!(url: url, code: code) }
      before { LinkStatService.new.link_showed!(link) }

      subject { get :stats, params: { shortcode: code }, format: :json }

      it { is_expected.to have_http_status(200) }

      it 'returns json with stats info' do
        expect(json_response[:redirectCount]).to eq 1
      end

      it 'returns a startDate' do
        start_date = Time.zone.parse(json_response[:startDate])
        expect(start_date.to_i).to eq link.created_at.to_i
      end

      it 'returns a lastSeenDate of a record' do
        expect(json_response).to include :lastSeenDate
      end
    end
    context 'link record exists and not visited before' do
      let!(:link) { Link.create!(url: url, code: code) }

      subject { get :stats, params: { shortcode: code }, format: :json }

      it { is_expected.to have_http_status(200) }

      it 'returns json with stats info' do
        expect(json_response[:redirectCount]).to eq 0
      end

      it 'returns a startDate' do
        start_date = Time.zone.parse(json_response[:startDate])
        expect(start_date.to_i).to eq link.created_at.to_i
      end

      it 'not returns a lastSeenDate of a record' do
        expect(json_response).to_not include :lastSeenDate
      end

    end

    context 'link record not exist' do
      subject { get :stats, params: { shortcode: 'notexist' }, format: :json }

      it { is_expected.to have_http_status(404) }
    end
  end
end
