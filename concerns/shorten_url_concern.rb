module Concerns
  class ShortenURL
    def initialize(attributes:, context:)
      @ctx   = context
      @attrs = attributes
    end

    def execute
      url = ShortURL.create(url: @attrs[:url], shortcode: @attrs[:shortcode])
      
      if url
        @ctx.created!({ shortcode: @attrs[:shortcode] })
      else
        @ctx.server_error!("URL couldn't be shortened. Please try again later")
      end
    end
  end
end
