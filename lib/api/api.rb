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
    end

    rescue_from Shorty::Errors::ExistingShortcodeError do |e|
      conflict_error(e.message)
    end
    
    rescue_from Shorty::Errors::InvalidShortcodeError do |e|  
      unprocessable_entity_error(e.message)
    end

    mount Shorty::PostShorten
  end
end
 