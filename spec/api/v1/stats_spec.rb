require_relative '../api_spec_helper'

describe ShortyUrl::API::V1 do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:url) { 'www.google.com' }
  let(:content_type) { 'application/json' }

  context 'GET /:shortcode/stats' do
    context "shortcode doesn't exist in the system" do
      let(:shortcode) { '123asd' }
      let(:status) { 404 }
      let(:error) { 'The shortcode cannot be found in the system' }

      before { get "/#{shortcode}/stats" }

      include_examples 'api:error'
    end

    context 'shortcode is present in the system' do
      let(:desired_shortcode) { '111asd' }
      let(:now) { Time.now }
      let(:startDate) { now.utc.iso8601 }

      before do
        allow(Time).to receive(:now).and_return(now)
        ShortyUrl.shortcode(url, desired_shortcode)
      end

      shared_examples ':startDate and :redirectCount properties' do
        it 'returns :startDate and redirectCount' do
          %w(redirectCount startDate).each do |property|
            body = JSON.parse(last_response.body)
            expect(body.keys).to include(property)
            expect(body[property]).to eq(send(property))
          end
        end
      end

      context "redirect wasn't issued" do
        let(:redirectCount) { 0 }

        before { get "/#{desired_shortcode}/stats" }

        include_examples ':startDate and :redirectCount properties'

        it "doesn't return lastSeenDate property" do
          expect(JSON.parse(last_response.body).keys).to_not include('lastSeenDate')
        end
      end

      context 'redirect was issued' do
        let(:redirectCount) { 3 }

        before do
          redirectCount.times { ShortyUrl.decode(desired_shortcode) }
          get "/#{desired_shortcode}/stats"
        end

        include_examples ':startDate and :redirectCount properties'

        it 'returns lastSeenDate property' do
          expect(JSON.parse(last_response.body).keys).to include('lastSeenDate')
        end
      end
    end
  end
end
