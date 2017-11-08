class Api::V1::ShortLinksController < ApplicationController
  before_action :find_stats, only: [:fetch_stats]

  api :POST, '/api/v1/shorten', 'Creating shortcodes'
  param :url, String, desc: 'full url', required: true
  param :shortcode, String, desc: 'preferential shortcode', required: false
  def create
    @short_link = ShortLink.new(short_link_params)
    json_response(@short_link.shortcode, :created) if @short_link.save!
  end

  api :GET, '/api/v1/fetch_short_code/:shortcode', 'Fetches shortcode and redirects to original url'
  param :shortcode, String, desc: 'preferential shortcode', required: false
  def fetch_short_code
    @short_link = ShortLink.find_by_shortcode!(params[:shortcode])
    json_response(@short_link.shortcode, 302, @short_link.url)
    update_stats_redirect_count
  end

  private

  def update_stats_redirect_count
    stats = @short_link.stat
    stats.tap do |stat|
      stat.redirect_count += 1
      stat.last_seen_date = DateTime.now.in_time_zone('UTC').iso8601
    end
    stats.save
  end

  def short_link_params
    params.permit(:url, :shortcode)
  end
end
