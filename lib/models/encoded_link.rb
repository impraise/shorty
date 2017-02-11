require "random_token"

class EncodedLink < ActiveRecord::Base
  SHORTCODE_REGEX = /\A[0-9a-zA-Z_]{6}\z/

  has_many :link_accesses

  validates_presence_of :shortcode, :url
  validates_uniqueness_of :shortcode
  validates_format_of :shortcode, with: SHORTCODE_REGEX

  before_validation :assign_shortcode, unless: :shortcode

  def stats
    stats = {
      startDate: created_at,
      redirectCount: redirect_count
    }
    stats[:lastSeenDate] = last_seen_date if redirect_count > 0
    stats
  end

  private

  def assign_shortcode
    until shortcode && EncodedLink.where(shortcode: shortcode).empty?
      self.shortcode = RandomToken.gen("%6?")
    end
  end

  def redirect_count
    link_accesses.count
  end

  def last_seen_date
    link_accesses.maximum(:created_at)
  end
end
