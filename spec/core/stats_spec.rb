describe ShortyUrl::Stats do
  let(:now) { Time.now }
  subject { described_class.new }

  context '#initialize' do
    it 'sets and formats :start_date with iso8601 format' do
      allow(Time).to receive(:now).and_return(now)
      expect(subject.start_date).to eq(now.utc.iso8601)
    end
  end

  context '#track_redirect!' do
    it 'increments redirect count' do
      expect { subject.track_redirect! }.to change(subject, :redirect_count).by(1)
    end

    it 'sets and formats :last_seen_date with iso8601 format' do
      allow(Time).to receive(:now).and_return(now)
      subject.track_redirect!

      expect(subject.last_seen_date).to eq(now.utc.iso8601)
    end
  end
end
