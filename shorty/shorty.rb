require 'hashids'
require 'uri'

#TODO private vs public

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
      self.shortcode = encode(self.id)
      save
    else
      add_to_collisions(self.shortcode, self.id)
    end
  end

  #Validation
  def validate
    super
    errors.add(:missing_url, 'url is not present') if url.nil?
    errors.add(:invalid_url, 'invalid url') unless url && valid_url?(url)
    validate_short_code(self.shortcode) if !self.shortcode.nil?
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

  def valid_url?(shortcode)
    uri = URI.parse(shortcode)
    %w( http https ).include?(uri.scheme)
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
    id = self.class.decode(shortcode)
    self.id == id || Shorty[id].nil?
  end

  #Encoding/Decoding
  def self.decode(shortcode)
    if collision = Collision.where(shortcode: shortcode).first
      collision.shorty_id
    else
      hashid.decode(shortcode).first
    end
  end

  def encode(id)
    code = self.class.hashid.encode(id)
    if collision = Collision.where(shortcode: code).first
      shortcode = encode(collision.shorty_id)
      add_to_collisions(shortcode, id)
      shortcode
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
    self.last_seen_date = Time.now.iso8601
    self.url if save #TODO error handling?
  end
end
