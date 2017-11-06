class Api::V1::ShortLinksController < ApplicationController

  def create
    @short_link = ShortLink.new(short_link_params)
    if @short_link.save
      render status: :created
    end
  end

  def get_short_code
    @short_link = ShortLink.find_by_shortcode(params[:shortcode])
  end

  private

  def short_link_params
    params.require(:short_link).permit(:url, :shortcode)
  end
end
