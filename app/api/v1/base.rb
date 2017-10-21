# frozen_string_literal: true

require_relative 'defaults'
require_relative 'shorten'
require_relative 'short_url'

module API
  # V1 Functionality
  module V1
    ## API v1 Configuration
    class Base < Grape::API
      include API::V1::Defaults

      version 'v1'

      add_swagger_documentation base_path: 'api',
        api_version: 'v1',
        add_base_path: true,
        hide_documentation_path: true

      mount API::V1::Shorten
      mount API::V1::ShortUrl
    end
  end
end
