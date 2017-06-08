require 'spec_helper'
require 'json'

RSpec.describe ShortyController::Stats do
  describe '.call' do
    subject { described_class.call('example') }

    context 'when shortcode exists' do
      let(:shorty) { double(Shorty, redirect_count: 2, created_at: DateTime.yesterday, last_seen_at: DateTime.current) }
      let(:expected_response) do
        {
          startDate:  shorty.created_at,
          lastSeenDate: shorty.last_seen_at,
          redirectCount: shorty.redirect_count
        }.to_json
      end

      before do
        allow(Shorty)
          .to receive(:find_by!)
          .and_return(shorty)
      end

      it 'returns status 200' do
        expect(subject.status).to eq 200
      end

      it 'returns JSON content_type' do
        expect(subject.content_type).to eq :json
      end

      it 'returns the expected response body' do
        expect(subject.body).to eq expected_response
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
