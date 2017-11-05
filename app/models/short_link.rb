class ShortLink < ApplicationRecord
  has_one :stat, dependent: :destroy

  validates :url, presence: true
  validates :shortcode, format: { with: /\A[0-9a-zA-Z_]{6}\z/i }

  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_".split(//)

  def generate_shortcode
    begin
      slug = (0...6).map { ALPHABET[rand(ALPHABET.length)] }.join
    end while ShortLink.find_by_shortcode(slug).present?
  end
end
