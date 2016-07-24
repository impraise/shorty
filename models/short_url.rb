class ShortURL
  attr_accessor :url, :shortcode, :created_at

  def initialize(url:, shortcode:)
    @client = Redis.client
    @url, @shortcode = url, shortcode
  end

  def save
    return false if @url.to_s.empty? || @shortcode.to_s.empty?

    @client.call("SET", "#{@shortcode}:created", @created_at) if @created_at
    !!@client.call("SET", @shortcode, @url)
  end

  def delete
    @client.call("DEL", "#{@shortcode}:created")
    @client.call("DEL", @shortcode)
  end

  def register_view
    @client.call("INCR", "#{@shortcode}:views")
  end

  def views
    @client.call("GET", "#{@shortcode}:views").to_i
  end

  def self.create(url:, shortcode:)
    short_url = self.new(url: url, shortcode: shortcode)
    short_url.created_at = Time.now.to_i
    short_url.save

    short_url
  end

  def self.fetch(shortcode)
    url = Redis.client.call("GET", shortcode)

    return nil unless url

    instance = self.new(url: url, shortcode: shortcode)
    instance.created_at = Redis.client.call("GET", "#{shortcode}:created")

    instance
  end
end
