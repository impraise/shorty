describe 'Shortcode' do
  describe '.random_shortcode' do
    subject { Shortcode.random_shortcode }

    it 'should return a string' do
      expect(subject.is_a?(String)).to eq(true)
    end

    it 'should be 6 characters' do
      expect(subject.length).to eq(6)
    end

    it 'should conform to ^[0-9a-zA-Z_]{6}$' do
      expect(!!subject.match(/^[0-9a-zA-Z_]{6}$/)).to eq(true)
    end

    context 'existing shortcode'
    context 'shortcode space is full'
  end
end

describe 'RedirectSummary' do
  describe '#increment!' do
    let!(:shortcode) { Shortcode.create(url: 'http://www.impraise.com') }
    let!(:summary) { RedirectSummary.create(shortcode: shortcode) }

    subject { summary.increment! }

    it 'should increment the redirect counter' do
      expect {
        subject
      }.to change { summary.reload.redirect_count }.from(0).to(1)
    end

    it 'should change updated_at' do
      pending 'possible bug in dm-timestamps'

      expect {
        subject
      }.to change { summary.reload.updated_at }
    end
  end
end
