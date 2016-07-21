module Api
  module V1
    class ShortnerController < ApplicationController
      # POST /api/v1/shorten
      def create
        link = CreateLinkService.new.call(url: params[:url], shortcode: params[:shortcode])

        render json: { shortcode: link.code }, status: :created
      rescue ApiErrors::CodeTaken => e
        render_error(e, status: 409)
      rescue ApiErrors::InvalidCode => e
        render_error(e, status: 422)
      rescue ApiErrors::Error => e
        render_error(e, status: 400)
      end
    end
  end
end
