require 'rails_helper'

RSpec.describe LinkStatService do
  include ActiveSupport::Testing::TimeHelpers

  let!(:link) { Link.create!(url: 'http://example.com') }
  let!(:current_time) { Time.zone.now }

  describe '#link_showed!' do
    context 'link not showed before' do
      it 'set the show count to 1' do
        subject.link_showed!(link)

        stats = LinkStat.find_by!(link: link)
        expect(stats.showed_count).to eq 1
      end

      it 'set the last seen time to the current time' do
        subject.link_showed!(link)

        stats = LinkStat.find_by!(link: link)
        expect(stats.last_seen_at).to be_within(1.second).of(current_time)
      end
    end

    context 'link stats record is exist before' do
      before { LinkStat.where(link: link).update_all(last_seen_at: 10.years.ago,
        showed_count: 1337) }

      it 'increments the show counter' do
        subject.link_showed!(link)

        expect(link.reload.stats.showed_count).to eq 1338
      end

      it 'update the last seen time' do
        subject.link_showed!(link)

        expect(link.reload.stats.last_seen_at).to be_within(1.second).of(current_time)
      end
    end
  end
end
