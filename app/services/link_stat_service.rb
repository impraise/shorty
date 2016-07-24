class LinkStatService
  def link_showed!(link)
    stats = LinkStat.find_or_initialize_by(link: link)

    stats.last_seen_at = Time.zone.now
    stats.showed_count += 1

    stats.save
  end
end
