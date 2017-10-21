# frozen_string_literal: true

# Serializes ShortUrls
class ShortUrlSerializer < ActiveModel::Serializer
  attributes :startDate, :redirectCount, :lastSeenDate

  # @return [String]
  def startDate
    iso_date(object.start_date)
  end

  # @return [Integer]
  def redirectCount
    object.redirect_count
  end

  # @return [String]
  def lastSeenDate
    return if object.last_seen_date.blank?
    iso_date(object.last_seen_date)
  end

  # Converts DateTime instances to
  #   {https://en.wikipedia.org/wiki/ISO_8601 ISO8601}
  #   formatted date strings
  # @param date [DateTime] Date to format
  # @return [String]
  def iso_date(date)
    date.iso8601
  end
end
