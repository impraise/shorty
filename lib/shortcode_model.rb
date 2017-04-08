require_relative 'redis_store'
require 'faker'

class ShortcodeModel < RedisStore
  PATTERN = /[0-9a-zA-Z_]{6}/

  def self.add_shortcode(shortcode, url)
    shortcode ||= generate_code
    data = {
      url: url,
      redirect_count: 0,
      start_date: now_in_iso,
      last_seen_date: nil
    }.to_json
    model.set(shortcode, data)
    shortcode
  end

  def self.find_shortcode(shortcode)
    model.get(shortcode)
  end

  def self.use_shortcode(shortcode)
    shortcode_found = JSON.parse(find_shortcode(shortcode))
    data = {
      url: shortcode_found['url'],
      redirect_count: shortcode_found['redirect_count'] + 1,
      start_date: shortcode_found['start_date'],
      last_seen_date: now_in_iso
    }.to_json
    model.set(shortcode, data)
    shortcode_found['url']
  end

  def self.generate_code
    random_code = ''
    loop do
      random_code = Faker::Base.regexify PATTERN
      break random_code unless find_shortcode(random_code)
    end
    random_code
  end

  def self.now_in_iso
    Time.now.iso8601
  end
end
