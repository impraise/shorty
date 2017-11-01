class ShortySerializer

  def initialize(shorty)
    @shorty = shorty
  end

  def to_json(*)
    data = {
      redirectCount: @shorty.redirect_count.to_s,
      startDate: @shorty.start_date.to_s,
      lastSeenDate: @shorty.last_seen_date.to_s
    }
    data[:errors] = @shorty.errors if @shorty.errors.any?
    data
  end
end
