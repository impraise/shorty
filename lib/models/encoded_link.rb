require "random_token"

class EncodedLink < ActiveRecord::Base
  SHORTCODE_REGEX = /\A[0-9a-zA-Z_]{6}\z/

  validates_presence_of :shortcode, :url
  validates_uniqueness_of :shortcode
  validates_format_of :shortcode, with: SHORTCODE_REGEX

  before_validation :assign_shortcode, unless: :shortcode

  private

  def assign_shortcode
    until shortcode && EncodedLink.where(shortcode: shortcode).empty?
      self.shortcode = RandomToken.gen("%6?")
    end
  end
end
