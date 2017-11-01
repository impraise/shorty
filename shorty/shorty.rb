require 'uri'

class Shorty < Sequel::Model
  #Initialization
  def initialize(url, shortcode = nil)
    super(url)
    shortcode = shortcode
  end

  def before_create
    super
    self.redirect_count = 0
    self.start_date = Time.now.iso8601
  end

  def after_create
    if self.shortcode.nil?
      self.shortcode = Shortcoder.encode(self.id)
      save
    else
      Shortcoder.add_to_collisions(self.shortcode, self.id)
    end
  end

  #Validation
  def validate
    super
    errors.add(:missing_url, 'url is not present') if url.nil?
    errors.add(:invalid_url, 'invalid url') unless url && valid_url?(url)
    validate_short_code(self.shortcode) if !self.shortcode.nil?
  end

  def valid_url?(shortcode)
    uri = URI.parse(shortcode)
    %w( http https ).include?(uri.scheme)
  end

  def validate_short_code(string)
    if invalid_shortcode_format?(string)
      errors.add(:invalid_shortcode, 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{6}$.')
    else
      if !shortcode_unique?(string)
        errors.add(:duplicated_shortcode, 'The desired shortcode is already in use. Shortcodes are case-sensitive.')
      end
    end
  end

  def invalid_shortcode_format?(shortcode)
    (shortcode =~ /\A\p{Alnum}{4,}\z/) != 0
  end

  def shortcode_unique?(shortcode)
    shortcode_not_in_collisions(shortcode) &&
    shortcode_not_in_shorties(shortcode)
  end

  def shortcode_not_in_collisions(shortcode)
    collision = Collision.where(shortcode: shortcode).first
    collision.nil? || collision.shorty_id == self.id
  end

  def shortcode_not_in_shorties(shortcode)
    id = Shortcoder.decode(shortcode)
    self.id == id || Shorty[id].nil?
  end

  # Getters
  def get_url
    self.redirect_count += 1
    self.last_seen_date = Time.now.iso8601
    self.url if save
  end
end
