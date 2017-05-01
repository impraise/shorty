require 'grape'
require 'shorty'
require 'shorty_api'
require 'helpers/error_handling_helper'

module Shorty
  class Api < Grape::API
    version 'v1', using: :header, vendor: 'shorty'

    content_type    :json, 'application/json'
    format          :json
    default_format  :json

    helpers ErrorHandlingHelper

    rescue_from Errors::Error do |e|
      handle_api_error(e)
    end

    mount ShortyApi
  end
end
