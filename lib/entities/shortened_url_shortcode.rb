module Shorty
  module Entities
    class ShortenedUrlShortcode < Grape::Entity
      expose :shortcode
    end
  end
end