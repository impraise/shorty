class Link < ApplicationRecord
  validates :url, presence: true
  validates :shortcode, presence: true, uniqueness: true,
                        format: {
                          with: /\A[0-9a-zA-Z_]{6}\z/,
                          message: 'Allow only alpha-numeric and underscore'
                        }

  class << self
    SHORTCODE_RANGE = [*'0'..'9', *'A'..'Z', *'a'..'z', '_'].freeze

    def generate_shortcode
      shortcode = Array.new(6) { SHORTCODE_RANGE.sample }.join
      shortcode = generate_shortcode unless Link.where(shortcode: shortcode).count == 0
      shortcode
    end
  end
end
