require 'rails_helper'

RSpec.describe ShortLink, type: :model do

  # checks if ShortLink has a 1 to 1 relation with Stat
  it { should have_one(:stat) }

  # checks if url is present
  it { should validate_presence_of(:url)}
end
