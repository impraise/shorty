describe ShortyUrl::Storage do
  let(:url) { 'www.google.com' }
  let(:shortcode) { 'asdf12' }
  subject { described_class.new }

  context '#add' do
    it 'adds new LINK instance to the store' do
      subject.add(shortcode, url)
      expect(subject.find(shortcode)).to be_a(described_class::LINK)
    end
  end

  context '#find' do
    it 'returns LINK instance with correct url' do
      subject.add(shortcode, url)
      link = subject.find(shortcode)

      expect(link.url).to eq(url)
    end
  end

  context '#delete' do
    it 'removes element from the storage' do
      subject.add(shortcode, url)
      subject.delete(shortcode)

      expect(subject.find(shortcode)).to be_nil
    end
  end
end
