class UrlAddress < ApplicationRecord
  validates :url, presence: true, format: URI.regexp(%w(http https))
  validates :shortcode, presence: true, format: /\A[0-9a-zA-Z_]{4,}\z/, uniqueness: { case_sensitive: true }

  before_validation :ensure_shortcode

  def register_access!
    increment!(:redirect_count)
  end

  def generate_shortcode!
    shortcode = SecureRandom.urlsafe_base64(4).tr('-', '_')
    generate_shortcode if !shortcode.match(/\A[0-9a-zA-Z_]{6}\z/) || self.class.exists?(shortcode: shortcode)
    shortcode
  end

  private

    def ensure_shortcode
      return if shortcode.present?
      self.shortcode = generate_shortcode!
    end
end
