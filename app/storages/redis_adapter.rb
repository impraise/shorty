require 'redis'

# = RedisAdapter
class RedisAdapter
  INTEGER_FIELDS = [:redirectCount].freeze
  DBS = %w(development test production).freeze

  # = SymRedis
  #
  # Overridde Hashify to return hash with symbolized keys.
  # See https://github.com/redis/redis-rb/issues/201
  class SymRedis < Redis
    def hgetall(key)
      synchronize do |client|
        client.call([:hgetall, key], &SymHashify)
      end
    end

    SymHashify = lambda do |array|
      hash = {}
      array.each_slice(2) do |field, value|
        value = nil if value == ''
        hash[field.to_sym] = value
      end
      hash
    end
  end

  def initialize
    @redis = SymRedis.new(db: DBS.find_index(Shorty.config[:env]))
  end

  def find(shortcode)
    record = @redis.hgetall(shortcode)

    return unless record.any?

    # Convert
    Hash[record.map do |key, value|
      [key, INTEGER_FIELDS.include?(key) ? Integer(value) : value]
    end]
  end

  def store(shortcode, url)
    return false if exists? shortcode

    record = {
      shortcode: shortcode,
      url: url,
      redirectCount: 0,
      startDate: Time.now.utc.iso8601.to_s,
      lastSeenDate: nil
    }

    @redis.mapped_hmset(shortcode, record)

    record
  end

  # :reek:DuplicateMethodCall
  def use(shortcode)
    return false unless exists? shortcode

    @redis.hincrby(shortcode, :redirectCount, 1)
    @redis.hset(shortcode, :lastSeenDate, Time.now.utc.iso8601.to_s)
  end

  def exists?(shortcode)
    @redis.exists shortcode
  end

  def reset
    @redis.flushdb
  end
end
