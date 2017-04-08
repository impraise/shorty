require 'redis'
require 'redis-namespace'

class RedisStore
  def self.collection(name)
    connection = Redis.new
    Redis::Namespace.new(name, redis: connection)
  end

  def self.model
    collection(self.class.name.downcase.sub('model', ''))
  end
end
