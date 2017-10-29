require 'hashids'
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
    self.start_date = Time.now
  end

  def after_create
    if self.shortcode.nil?
      self.shortcode = encode(self.id)
      save
    else
      add_to_collisions(self.shortcode, self.id)
    end
  end

  #Validation
  def validate
    super
    errors.add(:url, 'can not be empty') if url.empty?
    errors.add(:url, 'invalid url') unless valid_url?(url)
    validate_short_code(self.shortcode) if !self.shortcode.nil?
  end

  def validate_short_code(string)
    if invalid_shortcode_format?(string)
      errors.add(:shortcode, 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{6}$.')
    else
      if !shortcode_unique?(string)
        errors.add(:shortcode, 'The the desired shortcode is already in use. Shortcodes are case-sensitive.')
      end
    end
  end

  def valid_url?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  end

  def invalid_shortcode_format?(string)
    (string =~ /\A\p{Alnum}{6}\z/) != 0
  end

  def shortcode_unique?(string)
    id = self.class.decode(string)

    Collision.where(shortcode: string).first.nil? &&
    (self.id == id || Shorty[id].nil?)
  end

  #Encoding/Decoding
  def self.decode(shortcode)
    hashid.decode(shortcode)
  end

  def encode(id)
    code = self.class.hashid.encode(id)
    if collision = Collision.where(shortcode: code).first
      encode(collision.shorty_id)
    else
      code
    end
  end

  def self.hashid
    @@hashid ||= Hashids.new("not too much salt", 6)
  end

  def add_to_collisions(shortcode, shorty_id)
    Collision.create(shortcode: shortcode, shorty_id: shorty_id)
  end

  # Getters
  def get_url
    self.redirect_count += 1
    self.last_seen_date = Time.now
    self.url if save
  end
end
