require 'spec_helper'
require 'rails_helper'
require 'support/shared_factories'


RSpec.describe Stat, type: :model do
  include_context 'shared factories'

  # checks if Stat belongs to ShortLink
  it { should belong_to(:short_link) }
end
