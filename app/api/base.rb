# frozen_string_literal: true

require 'grape/active_model_serializers'
require_relative 'v1/base'

# Global API
module API
  # General API configuration
  class Base < Grape::API
    include Grape::ActiveModelSerializers

    prefix :api
    format :json
    use Grape::Middleware::Globals

    # Mounting point for API versions
    # and other endpoints at the /api level
    mount API::V1::Base
  end
end
