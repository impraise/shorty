module Concerns
  class ShortenURL
    def initialize(attributes:, context:)
      @ctx   = context
      @attrs = attributes
    end

    def execute
      result = @ctx.redis.call "SET", @attrs[:shortcode], @attrs[:url]
      
      if result == "OK"
        @ctx.created!({ shortcode: @attrs[:shortcode] })
      else
        @ctx.server_error!("URL couldn't be shortened. Please try again later")
      end
    end
  end
end
