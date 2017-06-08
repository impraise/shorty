require 'spec_helper'

RSpec.describe Shorty do
  describe '#update_visit_stats' do
    let(:shorty) { Shorty.create(url: 'foo.com', shortcode: 'shortcode') }
    let(:current_time) { DateTime.new(2017, 6, 8, 12) }
    before do
      allow(DateTime).to receive(:current).and_return(current_time)
    end

    it 'updates increases redirect_count by 1' do
      shorty.update_visit_stats
      shorty.reload
      expect(shorty.redirect_count).to eq 1
    end

    it 'updates last_seen_at with current time' do
      shorty.update_visit_stats
      shorty.reload
      expect(shorty.last_seen_at).to eq current_time
    end
  end
end
