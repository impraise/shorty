describe ShortyUrl do
  let(:url) { 'www.google.com' }

  context '.shortcode' do
    it 'returns shortcode with correct amount of symbols' do
      shortcode = described_class.shortcode(url)
      expect(shortcode.length).to eq(ShortyUrl::SHORT_CODE_LENGTH)
    end
  end

  context '.decode' do
    it 'returns url' do
      shortcode = described_class.shortcode(url)
      expect(described_class.decode(shortcode)).to eq(url)
    end
  end

  context '.stats' do
    it 'returns Stats instance' do
      shortcode = described_class.shortcode(url)
      expect(described_class.stats(shortcode)).to be_a(described_class::Stats)
    end
  end
end
