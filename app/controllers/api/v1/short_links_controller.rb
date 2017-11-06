class Api::V1::ShortLinksController < ApplicationController

  rescue_from ActionController::ParameterMissing, with: :bad_request

  def create
    @short_link = ShortLink.new(short_link_params)
    if @short_link.save
      render status: :created
    else
      render_errors(@short_link.errors)
    end
  end

  def get_short_code
    @short_link = ShortLink.find_by_shortcode(params[:shortcode])
    render status: 302, location: @short_link.url
  end

  private

  def render_errors(errors)
    err = errors.details[:shortcode][0][:error]
    case err
    when :taken
      @errors = 'shortcode already in use'
      render status: 409
    when :invalid
      @errors = 'shortcode has invalid format'
      render status: 422
    end
  end

  def bad_request
    @errors = 'url is not present'
    render status: 400
  end

  def short_link_params
    params.require(:short_link).permit(:url, :shortcode)
  end
end
