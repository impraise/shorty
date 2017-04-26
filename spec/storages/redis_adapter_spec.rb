RSpec.describe RedisAdapter do
  let(:adapter) { RedisAdapter.new }
  let(:shortcode) { 'ExampleLink' }
  let(:url) { 'https://example.com' }

  before(:each) do
    RedisAdapter.new.reset
  end

  describe '#find' do
    context 'with predefined code' do
      before do
        adapter.store(shortcode, url)
      end

      it 'retrieves the record' do
        expect(adapter.find(shortcode)).to be_a(Hash)
        expect(adapter.find(shortcode)).to have_key(:url)
        expect(adapter.find(shortcode)).to have_key(:startDate)
        expect(adapter.find(shortcode)).to have_key(:redirectCount)
        expect(adapter.find(shortcode)).to have_key(:lastSeenDate)
        expect(adapter.find(shortcode)[:lastSeenDate]).to be_nil
      end
    end

    it 'fails when there is no record' do
      expect(adapter.find('NoCode')).to be_nil
    end
  end

  describe '#store' do
    context 'with predefined code' do
      it 'stores the record' do
        expect(adapter.store(shortcode, url)).to be_a(Hash)
        expect(adapter.instance_variable_get(:@redis).dbsize).to eq 1
      end
    end
  end

  describe '#use' do
    context 'with predefined code' do
      before do
        adapter.store(shortcode, url)
        3.times { adapter.use(shortcode) }
      end

      it 'increments the redirectCount' do
        expect(adapter.find(shortcode)[:redirectCount]).to eq 3
      end
    end
  end

  describe '#exists?' do
    context 'with predefined code' do
      before do
        adapter.store(shortcode, url)
      end

      it 'checks if the record exists' do
        expect(adapter.exists?(shortcode)).to be_truthy
      end
    end

    it 'fails if there is no record for the shortcode' do
      expect(adapter.exists?('NoCode')).to be_falsey
    end
  end

  describe '#reset' do
    it 'resets the storage' do
      adapter.store(shortcode, url)
      expect(adapter.instance_variable_get(:@redis).dbsize).to eq 1

      adapter.reset
      expect(adapter.instance_variable_get(:@redis).dbsize).to eq 0
    end
  end
end
