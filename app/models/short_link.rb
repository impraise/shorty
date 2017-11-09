class ShortLink < ApplicationRecord
  has_one :stat, dependent: :destroy

  validates :url, presence: true
  validates :shortcode, uniqueness: true
  validates :shortcode, format: { with: /\A[0-9a-zA-Z_=-]{6}\z/i }, allow_nil: true

  before_create { generate_shortcode(:shortcode) }
  after_create :url_encode_date

  def generate_shortcode(shortcode)
    return if valid_preferential_shortcode?(shortcode)
    loop do
      self[shortcode] = SecureRandom.urlsafe_base64(4)
      break unless shortcode_exists?(shortcode)
    end
  end

  def valid_preferential_shortcode?(shortcode)
    !!(self[shortcode] =~ /\A[0-9a-zA-Z_]{6}\z/i) && !shortcode_exists?(shortcode)
  end

  def shortcode_exists?(shortcode)
    ShortLink.exists?(shortcode: self[shortcode])
  end

  def url_encode_date
    Stat.create!(start_date: DateTime.now.in_time_zone('UTC').iso8601, short_link_id: id)
  end
end
