require 'time'

module ShortyUrl
  class Stats
    attr_reader :start_date, :last_seen_date, :redirect_count

    def initialize
      @start_date = formatted(Time.now)
      @redirect_count = 0
    end

    def track_redirect!
      @last_seen_date = formatted(Time.now)
      @redirect_count += 1
    end

    private

    def formatted(time)
      time.utc.iso8601
    end
  end
end
