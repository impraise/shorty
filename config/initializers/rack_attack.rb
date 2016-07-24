class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('req/ip', limit: 100, period: 10.minutes, &:ip)
end
