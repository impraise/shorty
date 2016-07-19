class Link < ApplicationRecord
  validates :url, presence: true
  validates :code, presence: true
  validates :code, uniqueness: true
end
