class LinkStat < ApplicationRecord
  belongs_to :link

  def self.by_link_code(code)
    link = Link.includes(:stats).find_by!(code: code)
    link.stats
  end
end
