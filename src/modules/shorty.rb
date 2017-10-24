require 'securerandom'
require 'redis'

class Shorty
  @@redis = Redis.new
  attr_reader :url, :shortcode, :startDate, :attributes
  attr_accessor :lastSeenDate, :redirectCount

  def initialize(attributes)
    @url = attributes[:url]
    @shortcode = attributes[:shortcode] || generate_shortcode
    @startDate = attributes[:startDate] || Time.now
    @lastSeenDate = attributes[:lastSeenDate]
    @redirectCount = attributes[:redirectCount] || 0
    set_attributes
  end

  def update_counter
    self.lastSeenDate = Time.now.to_s
    self.redirectCount += 1
    set_attributes
    self.save
  end

  def save
    @@redis.set(shortcode, attributes.to_json)
  end

  def self.find(shortcode)
    saved_data = @@redis.get(shortcode)
    return nil unless saved_data
    shorty_attributes = JSON.parse(saved_data)
    Shorty.new(keys_as_symbols(shorty_attributes))
  end

  private

  def set_attributes
    @attributes = { url: @url,
                    shortcode: @shortcode,
                    startDate: @startDate,
                    lastSeenDate: @lastSeenDate,
                    redirectCount: @redirectCount }
  end

  def generate_shortcode
    shortcode = SecureRandom.hex(5)
    return shortcode if Shorty.find(shortcode).nil?
    generate_shortcode
  end

  def self.keys_as_symbols(hash)
    hash.inject({}){|result,(key, value)| result[key.to_sym] = value; result}
  end
end
