require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:url) { 'http://example.com' }
  let(:code) { nil }

  describe '#code' do
    subject { described_class.create!(url: url, code: code) }

    it 'presents on create' do
      expect(subject.code).to be_present
    end

    it 'matches the criteria' do
      criteria = /\A[0-9a-zA-Z_]{6}\z/
      expect(subject.code).to match(criteria)
    end

    it 'is uniq' do
      current_code = subject.code

      result = described_class.new(url: 'http://another.com', code: current_code)
      expect(result.id).to be_nil
    end

    context 'if a code assigned' do
      let(:code) { 'my_code' }

      it 'eq to the passed code' do
        expect(subject.code).to eq 'my_code'
      end
    end
  end

  describe '#save' do
    context 'there is no stats record' do
      it 'create stats record' do
        expect { described_class.create!(url: url, code: code) }.to change(LinkStat, :count).by(1)
      end
    end
  end
end
