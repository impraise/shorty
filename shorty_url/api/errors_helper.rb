module ShortyUrl
  class API < Grape::API
    module ErrorsHelper
      def shortcode_cannot_be_found
        error!('The shortcode cannot be found in the system', 404)
      end
    end
  end
end
