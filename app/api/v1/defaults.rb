# frozen_string_literal: true

module API
  module V1
    # Default V1 error handling
    module Defaults
      # Adds the defined methods in classes that include this module
      def self.included(target)
        endpoint_errors(target)
        internal_server_errors(target)
        record_not_found(target)
        grape_validation_errors(target)
      end

      # Handles validation errors raised by Grape::Exceptions
      def self.grape_validation_errors(target)
        target.class_eval do
          rescue_from Grape::Exceptions::ValidationErrors do |e|
            error!(e, 400, 'Content-Type' => 'text/json')
          end
        end
      end

      # Handles ActiveRecord::RecordNotFound
      def self.record_not_found(target)
        target.class_eval do
          rescue_from(ActiveRecord::RecordNotFound) do |e|
            error!(e.message, 404, 'Content-Type' => 'text/json')
          end
        end
      end

      # Handles errors specific to the requirements of the endpoints
      def self.endpoint_errors(target)
        target.class_eval do
          rescue_from(
            ActiveRecord::RecordInvalid,
            CustomErrors::InvalidShortCodeFormat) do |e|
              error!(e.message, 422, 'Content-Type' => 'text/json')
          end
        end
      end

      # Handles all other errors
      def self.internal_server_errors(target)
        target.class_eval do
          rescue_from(:all) do |e|
            target.logger.error e
            error!(e.message, 500, 'Content-Type' => 'text/json')
          end
        end
      end
    end
  end
end
