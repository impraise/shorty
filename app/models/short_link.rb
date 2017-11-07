class ShortLink < ApplicationRecord
  has_one :stat, dependent: :destroy

  validates :url, presence: true
  validates :shortcode, uniqueness: true
  validates :shortcode, format: { with: /\A[0-9a-zA-Z_]{6}\z/i }, allow_nil: true

  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_".split(//)

  before_create { generate_shortcode(:shortcode) }
  after_create :url_encode_date

  def generate_shortcode(shortcode)
    return if valid_preferential_shortcode?(shortcode)
    begin
      self[shortcode] = (0...6).map { ALPHABET[rand(ALPHABET.length)] }.join
    end while shortcode_exists?(shortcode)
  end

  def valid_preferential_shortcode?(shortcode)
    !!(self[shortcode] =~ /\A[0-9a-zA-Z_]{6}\z/i) && !shortcode_exists?(shortcode)
  end

  def shortcode_exists?(shortcode)
    ShortLink.exists?(shortcode: self[shortcode])
  end

  def url_encode_date
    Stat.create!(start_date: DateTime.now.iso8601, short_link_id: id)
  end
end
