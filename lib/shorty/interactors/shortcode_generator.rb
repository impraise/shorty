require 'shorty/repositories/shorties_repository'

module Shorty
  module Interactors
    class ShortcodeGenerator
      attr_reader :shorties_repository
      attr_reader :random_generator

      def initialize(environment)
        @shorties_repository = environment[:shorties_repository]
        @random_generator = environment[:random_generator]
      end

      def call
        generate_unique_shortcode(random_shortcode)
      end

      def generate_unique_shortcode(shortcode)
        while shorties_repository.find_by_shortcode shortcode
          shortcode = random_shortcode
        end

        shortcode
      end

      def random_shortcode
        random_generator.urlsafe_base64(4).tr('-', '_')
      end
    end
  end
end
