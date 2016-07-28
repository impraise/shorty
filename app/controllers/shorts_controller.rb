class ShortsController < ApplicationController
  before_action :set_short, only: [:show, :stats]

  # POST /shorten
  def create
    @short = Short.new(short_params)

    if @short.save
      render json: { "shortcode": @short.shortcode }, status: :created
    else
      render json: @short.errors, status: :unprocessable_entity
    end
  end

  # GET /:shortcode
  def show
    if @short
      @short.increment_count!

      head :found, location: @short.url
    else
      render json: { shortcode: "The shortcode cannot be found in the system" }, status: :not_found
    end
  end

  # GET /:shortcode/stats
  def stats
    if @short
      render json: {
                      "startDate": @short.created_at.iso8601,
                      "lastSeenDate": @short.updated_at.iso8601,
                      "redirectCount": @short.redirect_count
                    }
    else
      render json: { shortcode: "The shortcode cannot be found in the system" }, status: :not_found
    end
  end

  private

    def validate_params
      return "url is not present" unless short_params[:url]

    end

    def set_short
      @short = Short.find_by_shortcode(params[:shortcode])
    end

    def short_params
      params.permit(:url, :shortcode)
    end
end
