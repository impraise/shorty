class Link < ApplicationRecord
  validates :url, presence: true
  validates :shortcode, presence: true, uniqueness: true,
                        format: {
                          with: /\A[0-9a-zA-Z_]{6}\z/,
                          message: 'Allow only alpha-numeric and underscore'
                        }
end
