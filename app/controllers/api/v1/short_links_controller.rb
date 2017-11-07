class Api::V1::ShortLinksController < ApplicationController

  def create
    @short_link = ShortLink.new(short_link_params)
    json_response(@short_link.shortcode, :created) if @short_link.save!
  end

  def fetch_short_code
    @short_link = ShortLink.find_by_shortcode!(params[:shortcode])
    json_response(@short_link.shortcode, 302, @short_link.url)
  end

  private

  def short_link_params
    params.permit(:url, :shortcode)
  end
end
