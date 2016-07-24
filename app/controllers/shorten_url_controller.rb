class ShortenUrlController < ApplicationController
  def create
    @url_address = UrlAddress.new(shorten_params)

    if @url_address.save
      render json: { shortcode: @url_address.shortcode }, status: :created
    else
      head error_handler, content_type: 'application/json'
    end
  end

  def show
    url_address = UrlAddress.find_by(shortcode: shorten_params[:shortcode])

    if url_address && url_address.register_access!
      head :found, location: url_address.url, content_type: 'application/json'
    else
      head :not_found, content_type: 'application/json'
    end
  end

  def stats
    @url_address = UrlAddress.find_by(shortcode: shorten_params[:shortcode])

    if @url_address
      render json: @url_address, status: :ok
    else
      head :not_found, content_type: 'application/json'
    end
  end

  private

    def error_handler
      if @url_address.errors.added?(:shortcode, :invalid)
        :unprocessable_entity
      elsif @url_address.errors.added?(:shortcode, :taken)
        :conflict
      else
        :bad_request
      end
    end

    def shorten_params
      params.permit([:shortcode, :url])
    end
end
