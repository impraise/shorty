require 'rails_helper'

RSpec.describe Stat, type: :model do
  # checks if Stat belongs to ShortLink
  it { should belong_to(:short_link) }
end
