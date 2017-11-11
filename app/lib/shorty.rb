require 'securerandom'
require 'redis'

class Shorty
  attr_reader :url, :shortcode

  SHORTCODE_REGEX = /^[0-9a-zA-Z_]{6}$/

  def initialize(attributes)
    @url = attributes[:url]
    @shortcode = attributes[:shortcode]
  end

  # Save the Shorty attributes and return the saved Shorty record.
  def save
    # Check if the Shorty has a valid shortcode with the matching pattern.
    # If not, then generate a new one.
    shortcode = self.has_valid_shortcode? ? self.shortcode : self.generate_shortcode

    attributes = { url: self.url, shortcode: shortcode }
    Shorty.redis_conn.set(shortcode, attributes.to_json)

    Shorty.find(shortcode)
  end

  # Return the Shorty object from Redis.
  def self.find(shortcode)
    shorty_record = Shorty.redis_conn.get(shortcode)
    return nil unless shorty_record

    # Hash keys will be strings when parsed from Redis result, so convert it to symbols and
    # then initialize the record.
    Shorty.new(symbolize_hash_keys(JSON.parse(shorty_record)))
  end

  # Establish Redis connection
  def self.redis_conn
    @redis_conn ||= Redis.new
  end

  # Convert all the keys of the hash to symbols.
  def self.symbolize_hash_keys(hash)
    hash.each_with_object({}) do |(k, v), temp_hash|
      temp_hash[k.to_s.to_sym] = v
    end
  end

  # Returns uniq shortcode which matches ^[0-9a-zA-Z_]{6}$ pattern
  def generate_shortcode
    shortcode = SecureRandom.urlsafe_base64(4)

    # It's possible for the shortcode to have '-' character or the shortcode might already exist.
    # On such cases, do the regeneration.
    if shortcode.match(SHORTCODE_REGEX).nil? || Shorty.find(shortcode)
      return self.generate_shortcode
    end

    shortcode
  end

  def has_valid_shortcode?
    self.shortcode.to_s.match(SHORTCODE_REGEX)
  end
end

