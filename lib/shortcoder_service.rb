require 'pry' # REMOVE
require 'time'

class ShortcoderService
  @@client = Mongo::Client.new('mongodb://127.0.0.1:27017/shortener') # "#{ENV['MONGODB_URI']}")
  @@db     = @@client.database
  @@coll   = @@db[:sorts]

  REGEX_PATTERN = /^[0-9a-zA-Z_]{4,}$/

  def self.create_code(code, url)
    shortcode = code.nil? ? generate_code : code
    @@coll.insert_one(
      shortcode: shortcode,
      url: url,
      startDate: Time.now.utc.iso8601,
      lastSeenDate: '',
      redirectCount: 0
    )

    shortcode
  end

  def self.get_url_by(code)
    if code_valid?(code)
      # get url and update columns
    else
      # return a 404 error
    end
  end

  def self.code_present?(code)
    @@coll.find(shortcode: code).to_a.any?
  end

  def self.code_valid?(code)
    !(code !~ REGEX_PATTERN)
  end

  def self.generate_code
    code = ''
    loop do
      o = [('a'..'z'), ('A'..'Z'), %w('_'), (0..9)].map(&:to_a).flatten
      code = (0...6).map { o[rand(o.length)] }.join
      break code unless code_present?(code) || !code_valid?(code)
    end

    code
  end
end

# ShortcoderService.code_present?(code)

# @collection.insert_many(parsed_user)
# short = { shortcode: 'code', url: 'google.com' }
