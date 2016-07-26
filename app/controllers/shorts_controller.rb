class ShortsController < ApplicationController
  before_action :set_short, only: [:show, :stats]

  # POST /shorten
  def create
    @short = Short.new(short_params)

    if @short.save
      render json: @short, status: :created, location: @short
    else
      render json: @short.errors, status: :unprocessable_entity
    end
  end

  # GET /:shortcode
  def show
    render json: @short
  end

  # GET /:shortcode/stats
  def stats
    render json: @short
  end

  private

    def set_short
      @short = Short.find(params[:shortcode])
    end

    def short_params
      params.require(:short).permit(:url, :shortcode)
    end
end
