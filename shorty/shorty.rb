require 'hashids'
require 'uri'

class Shorty < Sequel::Model
  #TODO allow for preferential shortcode and tests

  def before_create
    super
    self.redirect_count = 0
    self.start_date = Time.now
  end

  def after_create
    if self.shortcode.nil?
      self.shortcode = encode(self.id)
      save
    end
  end

  #Validation
  def validate
    super
    errors.add(:url, "can't be empty") if url.empty?
    errors.add(:url, "invalid url type") if valid_url? url
  end

  def valid_url?(string)
    uri = URI.parse(string)
    !%w( http https ).include?(uri.scheme)
  end

  #Encoding/Decoding
  def self.decode(short_url)
    hashid.decode(short_url)
  end

  def encode(id)
    self.class.hashid.encode(id)
  end

  def self.hashid
    @@hashid ||= Hashids.new("not too much salt", 6)
  end

  # Getters
  def get_url
    self.redirect_count += 1
    self.last_seen_date = Time.now
    self.url if save
  end
end
