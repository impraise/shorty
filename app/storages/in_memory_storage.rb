# = InMemoryStorage
class InMemoryStorage
  def self.instance
    @instance ||= new
  end

  def initialize
    @records = {}
  end

  def find(shortcode)
    @records[shortcode]
  end

  def store(shortcode, url)
    return false if exists? shortcode

    @records[shortcode] = {
      url: url,
      redirectCount: 0,
      startDate: Time.now.iso8601,
      lastSeenDate: nil
    }
  end

  # :reek:DuplicateMethodCall
  def use(shortcode)
    return false unless exists? shortcode

    @records[shortcode][:redirectCount] += 1
    @records[shortcode][:lastSeenDate] = Time.now.iso8601
  end

  def exists?(shortcode)
    @records.key? shortcode
  end

  def reset
    @records = {}
  end
end
