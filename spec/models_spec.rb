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

  describe '#conforms?' do
    let!(:instance) { Shortcode.new(shortcode: shortcode, url: 'http://www.impraise.com') }

    subject { instance.conforms? }

    context 'matches format' do
      let!(:shortcode) { 'asdf1234' }

      it 'should return true' do
        expect(subject).to eq(true)
      end
    end

    context 'does not match format' do
      let!(:shortcode) { 'bad :(' }

      it 'should return false' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#increment!' do
    let!(:shortcode) { Shortcode.create(url: 'http://www.impraise.com') }

    subject { shortcode.increment! }

    it 'should increment the redirect counter' do
      expect {
        subject
      }.to change { shortcode.reload.redirect_count }.from(0).to(1)
    end

    it 'should change updated_at' do
      shortcode.update!(updated_at: DateTime.now - 100)

      expect {
        subject
      }.to change { shortcode.reload.updated_at }
    end
  end
end