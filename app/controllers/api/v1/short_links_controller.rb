class Api::V1::ShortLinksController < ApplicationController

  def create
  end

  def get_short_code
    @short_link = ShortLink.find_by_shortcode(params[:shortcode])
  end

  def index
    @short_links = ShortLink.all
  end

  private

  def short_link_params
    params.permit(:url, :shortcode)
  end
end
