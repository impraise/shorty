class ShortenController < ApplicationController
  before_action :verify_request_format!
  before_action :validate_url, only: [:create]
  before_action :validate_shortcode, only: [:create]

  def create
    link = Link.new(link_params)
    link.shortcode = Link.generate_shortcode unless link_params[:shortcode]

    render json: { shortcode: link.shortcode }, status: :created if link.save
  end

  def show
    if (link = Link.find_by(shortcode: params[:shortcode]))
      link.increment(:redirects).save
      head :found, content_type: 'application/json', location: link.url
    else
      head :not_found, content_type: 'application/json'
    end
  end

  def stats
    if (link = Link.find_by(shortcode: params[:shortcode]))
      render json: link, status: :ok
    else
      head :not_found, content_type: 'application/json'
    end
  end

  protected

  # Check if url present
  def validate_url
    return head(:bad_request, content_type: 'application/json') unless params[:shorten][:url]
  end

  # Check if shortcode valid and uniq
  def validate_shortcode
    return unless params[:shorten][:shortcode].present?
    return head(:unprocessable_entity,
                content_type: 'application/json') unless Link.shortcode_valid?(params[:shorten][:shortcode])
    return head(:conflict,
                content_type: 'application/json') unless Link.shortcode_uniq?(params[:shorten][:shortcode])
  end

  def link_params
    params.require(:shorten).permit(:url, :shortcode)
  end
end
