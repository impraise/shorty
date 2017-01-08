require 'time'
require 'faker'
require 'envyable'
Envyable.load('config/env.yml')

class ShortcoderService
  def initialize
    @client = Mongo::Client.new(ENV['MONGODB_URI'])
    @db     = @client.database
    @coll   = @db[:shorts]
    @coll.indexes.create_one({ shortcode: 1 }, unique: true)
  end

  REGEX_PATTERN = /^[0-9a-zA-Z_]{4,}$/

  def create_code(code, url)
    shortcode = code.nil? ? generate_code : code
    @coll.insert_one(
      shortcode: shortcode,
      url: url,
      startDate: Time.now.utc.iso8601,
      lastSeenDate: '',
      redirectCount: 0
    )

    shortcode
  end

  def get_url_by(code)
    return '404' unless code_present?(code)

    short = @coll.find(shortcode: code).first

    @coll.update_one(
      { shortcode: code },
      '$set' => {
        'redirectCount' => short['redirectCount'] += 1,
        'lastSeenDate' => Time.now.utc.iso8601
      }
    )

    short['url']
  end

  def get_stats_for(code)
    if code_present?(code)
      short = @coll.find(shortcode: code).first

      {
        'startDate' => short['startDate'],
        'lastSeenDate' => short['lastSeenDate'],
        'redirectCount' => short['redirectCount']
      }
    else
      '404'
    end
  end

  def code_present?(code)
    @coll.find(shortcode: code).to_a.any?
  end

  def code_valid?(code)
    !(code !~ REGEX_PATTERN)
  end

  private

  def generate_code
    code = ''

    loop do
      code = Faker::Base.regexify(/^[0-9a-zA-Z_]{6}$/)
      break code unless code_present?(code)
    end

    code
  end
end
