class ShortLink < ApplicationRecord
  has_one :stat, dependent: :destroy

  validates :url, presence: true
  validates :shortcode, uniqueness: true
  validates :shortcode, format: { with: /\A[0-9a-zA-Z_]{6}\z/i }, allow_nil: true

  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_".split(//)

  before_create { generate_shortcode(:shortcode) }

  def generate_shortcode(shortcode)
    begin
      self[shortcode] = (0...6).map { ALPHABET[rand(ALPHABET.length)] }.join
    end while shortcode_exists?(shortcode)
  end

  def shortcode_exists?(shortcode)
    ShortLink.exists?(shortcode: self[shortcode])
  end

end
