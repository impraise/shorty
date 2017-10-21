# frozen_string_literal: true

describe API::V1::Shorten, type: :api do
  let(:params) do
    {
      url: Faker::Internet.url,
      shortcode: ''.rjust(6, SecureRandom.base64).gsub(/\+|=|\//, '_')
    }
  end

  subject { post 'api/v1/shorten', params }


  describe 'Requested with invalid parameters' do
    context 'when invalid url' do
      it 'returns 400 Bad Request when missing' do
        params.delete(:url)
        subject
        expect(last_response.status).to eq(400)
      end

      it 'returns 400 Bad Request when not a String' do
        params[:url] = []
        subject
        expect(last_response.status).to eq(400)
      end

      it 'returns 400 Bad Request when format is invalid' do
        params[:url] = 'http://0.123.0034/whatever'
        subject
        expect(last_response.status).to eq(400)
      end
    end

    context 'when invalid short_code' do
      it 'returns 400 Bad Request when not a String' do
        params[:shortcode] = []
        subject
        expect(last_response.status).to eq(400)
      end

      describe '422 Unprocessable Entity' do
        it 'when format is invalid' do
          params[:shortcode] = '+shrt+'
          subject
          expect(last_response.status).to eq(422)
        end

        it 'when short_code is long' do
          params[:shortcode] = 'notashortcode'
          subject
          expect(last_response.status).to eq(422)
        end
      end

      it 'returns 409 Conflict when already exists' do
        short_code = '123456'
        create(:short_url, short_code: short_code)
        params[:shortcode] = short_code
        subject

        expect(last_response.status).to eq(409)
      end
    end
  end

  describe 'correct parameters' do
    it 'returns 201 Created' do
      subject
      expect(last_response.status).to eq(201)
    end

    it 'creates a new ShortUrl' do
      expect { subject }.to change { ShortUrl.count }.by 1
    end

    it 'creates a new ShortUrl when shortcode param is nil' do
      params.delete(:shortcode)
      expect { subject }.to change { ShortUrl.count }.by 1
    end
  end
end
