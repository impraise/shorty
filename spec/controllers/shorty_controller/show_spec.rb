require 'spec_helper'
require 'json'

RSpec.describe ShortyController::Show do
  describe '.call' do
    subject { described_class.call('example') }

    context 'when shortcode exists' do
      let(:shorty) { double(Shorty, redirect_count: 0, url: 'http://example.com') }
      before do
        allow(Shorty)
          .to receive(:find_by!)
          .and_return(shorty)

        allow(shorty)
          .to receive(:update_visit_stats)
      end

      it 'returns status 302' do
        expect(subject.status).to eq 302
      end

      it 'returns JSON content_type' do
        expect(subject.content_type).to eq :json
      end

      it 'returns the expected URL as the response body' do
        expect(subject.body).to eq 'http://example.com'
      end
    end

    context 'when shortcode does not exist' do
      before do
        allow(Shorty)
          .to receive(:find_by!)
          .and_raise(ActiveRecord::RecordNotFound)
      end

      let(:expected_response) { { error: "The shortcode could not be found in the system" }.to_json }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'returns JSON content_type' do
        expect(subject.content_type).to eq :json
      end

      it 'returns the expected response body' do
        expect(subject.body).to eq expected_response
      end
    end
  end
end
