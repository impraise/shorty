module ShortyUrl
  class Storage
    LINK = Struct.new(:url, :stats)

    def initialize
      @storage = {}
    end

    def add(shortcode, url)
      @storage[shortcode] = LINK.new(url, Stats.new)
    end

    def find(shortcode)
      @storage[shortcode]
    end

    def delete(shortcode)
      @storage.delete(shortcode)
    end

    def clear!
      @storage = {}
    end
  end
end
