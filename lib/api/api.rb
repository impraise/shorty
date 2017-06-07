module Shorty
  class API < Grape::API
    content_type :json, 'application/json'

    format :json
    default_format :json

    helpers do
      def conflict_error(message)
        error!({ error: message }, 409)
      end

      def unprocessable_entity_error(message)
        error!({ error: message }, 422)
      end

      def not_found_error(message)
        error!({ error: message }, 404)
      end
    end

    rescue_from Shorty::Errors::ExistingShortcodeError do |e|
      conflict_error(e.message)
    end
    
    rescue_from Shorty::Errors::InvalidShortcodeError do |e|  
      unprocessable_entity_error(e.message)
    end

    rescue_from Shorty::Errors::NotFoundShortcodeError do |e|  
      not_found_error(e.message)
    end

    mount Shorty::PostShorten
    mount Shorty::GetShortcode
    mount Shorty::GetShortcodeStats
  end
end
 