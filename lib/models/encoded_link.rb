class EncodedLink < ActiveRecord::Base
  SHORTCODE_REGEX = /\A[0-9a-zA-Z_]{6}\z/

  validates_presence_of :shortcode, :url
  validates_uniqueness_of :shortcode
  validates_format_of :shortcode, with: SHORTCODE_REGEX
end
