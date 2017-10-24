class Shorty
  attr_reader :url, :shortcode, :datastorage

  def initialize(url, shortcode, datastorage)
    @url = url
    @shortcode = shortcode
    @datastorage = datastorage
  end

  def process
    @shortcode ||= generate_shortcode
    {url: url, shortcode: shortcode, startDate: Time.now, lastSeenDate: nil, redirectCount: 0}
  end

  private

  def generate_shortcode
    shortcode = SecureRandom.hex(5)
    return shortcode if datastorage[shortcode].nil?
    generate_shortcode
  end
end
