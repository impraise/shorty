require 'securerandom'

# = Shortcode
#
# A primitive model to store and retrieve shortcodes with metadata
class Shortcode
  ALPHABET = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  ALPHABET_SIZE = ALPHABET.size

  EXPOSED_STATS = %i[redirectCount startDate lastSeenDate].freeze

  class << self
    def find(shortcode)
      record = Storage.instance.find(shortcode)

      raise ShortcodeNotFound unless record

      new(record)
    end

    def create(url, shortcode = nil)
      record = new(url: url, shortcode: shortcode)

      record.store

      record
    end
  end

  def initialize(record)
    @record = record
  end

  def shortcode?
    shortcode && !shortcode.empty?
  end

  def stats
    @record.select do |key, value|
      (EXPOSED_STATS.include? key) && value
    end
  end

  def shortcode
    @record[:shortcode]
  end

  def url
    @record[:url]
  end

  def store
    validate_url
    validate_shortcode

    storage.store(shortcode, url)
  end

  def use
    storage.use(shortcode)

    reload
  end

  private

  def reload
    @record = storage.find(shortcode)
  end

  # :reek:UtilityFunction
  def storage
    Storage.instance
  end

  def validate_url
    raise UndefinedUrl unless url
    raise MalformedUrl unless url =~ /^#{URI.regexp}$/
  end

  def validate_shortcode
    if shortcode?
      raise DuplicateShortcode if storage.exists? shortcode
      raise MalformedShortcode unless shortcode =~ /^[0-9a-zA-Z_]{4,}$/
    else
      assign_shortcode
    end
  end

  # :reek:UncommunicativeMethodName
  # :reek:UtilityFunction
  def number_to_base62(number, buffer = '')
    return '0' if number.zero?

    while number > 0
      buffer << ALPHABET[number.modulo(ALPHABET_SIZE)]
      number /= ALPHABET_SIZE
    end

    buffer.reverse!

    buffer
  end

  def assign_shortcode
    loop do
      shortcode = generate_shortcode

      continue if storage.exists? shortcode

      @record[:shortcode] = shortcode

      break
    end
  end

  def generate_shortcode(length = 6)
    number = SecureRandom.random_number(ALPHABET_SIZE**length)
    number_to_base62(number).rjust(length, '0')
  end
end
