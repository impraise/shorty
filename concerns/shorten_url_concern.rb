module Concerns
  class ShortenURL
    def initialize(attributes:, context:)
      @ctx   = context
      @attrs = attributes
    end

    def execute
      saved = @ctx.redis.call "SET", @attrs[:shortcode], @attrs[:url]
      
      if saved
        @ctx.created!({ shortcode: @attrs[:shortcode] })
      else
        @ctx.server_error!("URL couldn't be shortened. Please try again later")
      end
    end
  end
end
