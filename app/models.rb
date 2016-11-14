DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/#{ENV['RACK_ENV']}.sqlite")

class Shortcode
  include DataMapper::Resource

  RANDOM_SHORTCODE_LENGTH = 6
  RANDOM_SHORTCODE_FORMAT = /^[0-9a-zA-Z_]{6}$/
  MAX_RANDOM_SHORTCODE_ITERATIONS = 100
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
    iterations = 0

    begin
      random_shortcode = gen_random_shortcode
      conforms = !(random_shortcode.match(RANDOM_SHORTCODE_FORMAT).nil?)
      available = Shortcode.first(shortcode: random_shortcode).nil?
      iterations += 1
    end until (conforms && available) || (iterations >= MAX_RANDOM_SHORTCODE_ITERATIONS)

    (iterations >= MAX_RANDOM_SHORTCODE_ITERATIONS) ? nil : random_shortcode
  end

  def increment!
    adjust!(redirect_count: +1)
    # this is necessary due to the way dm-adjust constructs queries
    update(updated_at: DateTime.now)
  end

  private
    def self.gen_random_shortcode
      SecureRandom.urlsafe_base64(RANDOM_SHORTCODE_LENGTH).gsub(/\W/, '_')[0...RANDOM_SHORTCODE_LENGTH]
    end
end

DataMapper.finalize
DataMapper.auto_upgrade!
