require 'spec_helper'
require_relative '../../lib/generate_short_code'

RSpec.describe GenerateShortCode do
  describe '#call' do
    it 'returns a string with passed length' do
      result = subject.call(10)
      expect(result.size).to eq 10
    end

    it 'returns 6-symbol string by default' do
      result = subject.call
      expect(result.size).to eq 6
    end

    it 'match regexp' do
      10.times do
        expect(subject.call).to match(/\A[0-9a-zA-Z_]*\z/)
      end
    end
  end
end
