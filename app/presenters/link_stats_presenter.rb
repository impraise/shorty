class LinkStatsPresenter
  extend Forwardable
  def_delegator :@stats_record, :showed_count

  def initialize(stats_record)
    @stats_record = stats_record
  end

  def start_date
    @stats_record.link.created_at.iso8601(3)
  end

  def last_seen_date
    @stats_record.last_seen_at.iso8601(3) if @stats_record.showed_count > 0
  end
end
