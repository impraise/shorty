describe 'Shortcode' do
  let(:url) { 'http://www.impraise.com' }

  context 'default values' do
    subject { Shortcode.create(url: url) }

    it 'should assign shortcode' do
      expect(subject.shortcode).to_not eq(nil)
    end

    it 'should assign redirect_count' do
      expect(subject.redirect_count).to eq(0)
    end
  end

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

    context 'existing shortcode is randomly selected' do
      let(:shortcode) { 'existing' }

      before do
        Shortcode.create(shortcode: shortcode, url: url)
        expect(Shortcode).to receive(:gen_random_shortcode).and_return(shortcode).once
        expect(Shortcode).to receive(:gen_random_shortcode).and_call_original
      end

      it 'should assign another' do
        expect(subject).to_not eq(shortcode)
        expect(subject).to_not eq(nil)
      end
    end

    context 'shortcode keyspace is too full' do
      let(:shortcode) { 'XXXXXX' }

      before do
        Shortcode.create(shortcode: shortcode, url: url)
      end

      it 'should return nil' do
        expect(Shortcode).to receive(:gen_random_shortcode).and_return(shortcode).at_least(:once)
        expect(subject).to eq(nil)
      end

      it 'should run a fixed number of iterations' do
        expect(Shortcode).to receive(:gen_random_shortcode).and_return(shortcode).exactly(Shortcode::MAX_RANDOM_SHORTCODE_ITERATIONS).times
        subject
      end
    end
  end

  describe '#increment!' do
    let!(:shortcode) { Shortcode.create(url: url) }

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