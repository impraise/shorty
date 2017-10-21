# frozen_string_literal: true

module API
  module V1
    ##
    # This endpoint is used to create ShortUrl(s)
    # @see ShortUrl
    ##
    class Shorten < Grape::API
      rescue_from(CustomErrors::ShortCodeAlreadyInUse) do |e|
        error!(
          e.message,
          409,
          'Content-Type' => 'text/json'
        )
      end

      namespace :shorten do
        desc "creates a new short url and shorten's it"
        params do
          requires :url, type: String, regexp: URL_REGEX
          optional :shortcode, type: String, as: :short_code
        end
        post do
          declared_params = declared(params)

          short_url = ::URLs::Shortener.new(declared_params).shortify!
          status(201)
          short_url.as_json(only: :short_code)
        end
      end
    end
  end
end
