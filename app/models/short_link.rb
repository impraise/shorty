class ShortLink < ApplicationRecord
  has_one :stat, dependent: :destroy

  validates :url, presence: true
end
