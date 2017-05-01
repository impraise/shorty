require 'shorty/entities/shorty'

module Shorty
  module Interactors
    class CreateShorty
      attr_reader :shorties_repository
      attr_reader :shortcode_generator

      def initialize(environment)
        @shorties_repository = environment[:shorties_repository]
        @shortcode_generator = environment[:shortcode_generator]
      end

      def call(url:, shortcode: nil)
        shortcode ||= shortcode_generator.call

        shorty = Shorty.new(url: url, shortcode: shortcode)
        return shorty if shorties_repository.create(shorty)

        raise Errors::ShortcodeAlreadyExistsError
      end
    end
  end
end
