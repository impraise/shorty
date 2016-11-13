DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/#{ENV['RACK_ENV']}.sqlite")

class Shortcode
  include DataMapper::Resource

  RANDOM_SHORTCODE_LENGTH = 6
  RANDOM_SHORTCODE_FORMAT = /^[0-9a-zA-Z_]{6}$/
  REQUIRED_SHORTCODE_FORMAT = /^[0-9a-zA-Z_]{4,}$/

  property :id, Serial
  property :shortcode,  String, required: true, key: true, unique: true, default: ->(r,p)  { Shortcode.random_shortcode }
  property :url, String, required: true, length: 2000
  property :redirect_count, Integer, required: true, default: 0
  timestamps :at

  validates_uniqueness_of :shortcode, message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."
  validates_format_of :shortcode, with: REQUIRED_SHORTCODE_FORMAT, message: "The shortcode fails to meet the following regexp: #{REQUIRED_SHORTCODE_FORMAT.to_s}."
  validates_format_of :url, as: :url, message: "The URL is invalid."

  def self.random_shortcode
    begin
      random_shortcode = SecureRandom.urlsafe_base64(RANDOM_SHORTCODE_LENGTH).gsub(/\W/, '_')[0...RANDOM_SHORTCODE_LENGTH]
      conforms = !(random_shortcode.match(RANDOM_SHORTCODE_FORMAT).nil?)
      available = Shortcode.first(shortcode: random_shortcode).nil?
    end until conforms && available

    random_shortcode
  end

  def conforms?
    !!self.shortcode.match(REQUIRED_SHORTCODE_FORMAT)
  end

  def increment!
    adjust!(redirect_count: +1)
    # TODO: figure out why this is necessary
    update(updated_at: DateTime.now)
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
