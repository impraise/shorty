DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/#{ENV['RACK_ENV']}.sqlite")

class Shortcode
  include DataMapper::Resource

  RANDOM_SHORTCODE_LENGTH = 6

  has 1, :redirect_summary

  property :id,  String, required: true, key: true, unique: true, default: -> { Shortcode.random_shortcode }
  property :url, String, required: true, length: 2000
  timestamps :created_at

  validates_uniqueness_of :id, message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."
  validates_format_of :id, with: /^[0-9a-zA-Z_]{4,}$/, message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."
  validates_format_of :url, as: :url, message: "The URL is invalid."

  def self.random_shortcode
    begin
      random_shortcode = SecureRandom.urlsafe_base64(RANDOM_SHORTCODE_LENGTH).sub(/\W/, '_')
      existing = Shortcode.get(random_shortcode)
    end until existing.nil?

    random_shortcode
  end
end

class RedirectSummary
  include DataMapper::Resource

  belongs_to :shortcode

  property :id, Serial
  property :redirect_count, Integer, required: true, default: 0
  timestamps :updated_at

  def increment!
    adjust!(redirect_count: +1)
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
