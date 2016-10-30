describe ShortyUrl do
  let(:url) { 'www.google.com' }

  context '.shortcode' do
    context "shortcode doesn't exist in the system" do
      it 'returns shortcode with correct amount of symbols' do
        shortcode = described_class.shortcode(url)
        expect(shortcode.length).to eq(ShortyUrl::SHORT_CODE_LENGTH)
      end
    end

    context 'shortcode is already in use' do
      it 'raises error' do
        shortcode = described_class.shortcode(url)
        expect { described_class.shortcode(url, shortcode) }
          .to raise_error(::ShortyUrl::ShortCodeAlreadyInUseError)
      end
    end
  end

  context '.decode' do
    let(:redirect_count) { 3 }
    let(:shortcode) { '222asd' }
    let(:new_time) { Time.at(Time.now.to_i + 3000) }

    context 'shortcode exists in the system' do
      before { described_class.shortcode(url, shortcode) }

      it 'returns url' do
        expect(described_class.decode(shortcode)).to eq(url)
      end

      it 'increments number of redirects' do
        redirect_count.times { described_class.decode(shortcode) }
        expect(described_class.stats(shortcode).redirect_count).to eq(redirect_count)
      end

      it 'changes :last_seen_date property' do
        described_class.decode(shortcode)
        old_time = described_class.stats(shortcode).last_seen_date

        allow(Time).to receive(:now).and_return(new_time)
        described_class.decode(shortcode)

        expect(described_class.stats(shortcode).last_seen_date).to_not eq(old_time)
      end
    end

    context "shortcode doesn't exist in the system" do
      it 'returns nil' do
        expect(described_class.decode(shortcode)).to be_nil
      end
    end
  end

  context '.stats' do
    context 'shortcode exists in the system' do
      it 'returns STATS instance' do
        shortcode = described_class.shortcode(url)
        expect(described_class.stats(shortcode)).to be_a(described_class::STATS)
      end
    end

    context "shortcode doesn't exist in the system" do
      it 'returns nil' do
        expect(described_class.stats('123asd')).to be_nil
      end
    end
  end
end
