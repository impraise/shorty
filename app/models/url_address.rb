class UrlAddress < ApplicationRecord
  validates :url, presence: true, format: URI.regexp(%w(http https))
  validates :shortcode, presence: true,
                        uniqueness: { case_sensitive: true, message: 'the the desired shortcode is already in use' },
                        format: { with: /\A[0-9a-zA-Z_]{6}\z/, message: 'must have six alphanumeric chars and/or underscore' }

  before_validation :ensure_shortcode

  def register_access!
    increment!(:redirect_count)
  end

  protected
    def ensure_shortcode
      return if shortcode.present?
      self.shortcode = generate_shortcode
    end

    def generate_shortcode
      shortcode = SecureRandom.urlsafe_base64(4).tr('-', '_')
      generate_shortcode if self.class.exists?(shortcode: shortcode)
      shortcode
    end
end
