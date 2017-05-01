require 'shorty/errors/error'

module Shorty
  module Interactors
    class FindShorty
      attr_reader :shorties_repository

      def initialize(environment)
        @shorties_repository = environment[:shorties_repository]
      end

      def call(shortcode:)
        shorty = shorties_repository.find_and_increment_shortcode(shortcode)

        shorty || shorty_not_found
      end

      def shorty_not_found
        raise Errors::ShortyNotFoundError
      end
    end
  end
end
