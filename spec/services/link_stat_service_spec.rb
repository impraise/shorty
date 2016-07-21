require 'rails_helper'

RSpec.describe LinkStatService do
  include ActiveSupport::Testing::TimeHelpers

  let!(:link) { Link.create!(url: 'http://example.com') }
  let!(:current_time) { Time.zone.now }

  describe '#link_showed!' do
    context 'link stats not exist before' do
      it 'create a record' do
        expect { subject.link_showed!(link) }.to change(LinkStat, :count).by(1)
      end

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

    context 'link exist before' do
      let!(:stats) { LinkStat.create(link: link, last_seen_at: 10.years.ago, showed_count: 1337) }

      it 'increments the show counter' do
        subject.link_showed!(link)

        expect(stats.reload.showed_count).to eq 1338
      end

      it 'update the last seen time' do
        subject.link_showed!(link)

        expect(stats.reload.last_seen_at).to be_within(1.second).of(current_time)
      end
    end
  end
end
