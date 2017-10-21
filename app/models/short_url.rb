# frozen_string_literal: true

##
# ShortUrl is responsible for tracking shortened urls.
# @attr url [String] The original url to be shortened.
#   Must be present.
#   The url format is validated against
#   URL_REGEX in {file:config/initializers/constants/url_regex.rb}.
# @attr short_code [String] The short code used to shorten the url.
#   Must be present.
#   The short_code format is validated against
#   SHORT_CODE_REGEX in
#   {file:config/initializers/constants/short_code_regex.rb}.
# @attr redirect_count [Integer] Tracks the number of times the
#   shortened url has been requested.
# @attr start_date [DateTime] The date when the url was encoded,
# @attr last_seen_date [Date] Date of the last time a redirect was issued.
#   Only available if {#redirect_count} is greater than 0.
##
class ShortUrl < ActiveRecord::Base
  # Validations
  #
  validates :url, presence: true, format: { with: URL_REGEX }
  validates :redirect_count, numericality: true
  validates :start_date, presence: true
  validates :last_seen_date,
    presence: true,
    if: -> { redirect_count > 0 }

  validates :short_code,
    presence: true,
    length: { is: 6 },
    format: { with: SHORT_CODE_REGEX }
end
