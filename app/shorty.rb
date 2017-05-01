require 'dry-container'
require 'securerandom'
require 'shorty/config'

module Shorty
  module_function

  def dependencies(container: Dry::Container.new, eagerly_initialize: true)
    require 'shorty/repositories/shorties_repository'
    require 'shorty/entities/shorty'

    require 'shorty/interactors/create_shorty'
    require 'shorty/interactors/find_shorty'
    require 'shorty/interactors/find_shorty_stats'
    require 'shorty/interactors/shortcode_generator'

    require 'shorty/errors/codes'
    require 'shorty/errors/error'

    container.register(:shorties_repository, memoize: true) do
      ShortiesRepository.new
    end
    container.register(:shortcode_generator, memoize: true) do
      Interactors::ShortcodeGenerator.new(container)
    end
    container.register(:create_shorty, memoize: true) do
      Interactors::CreateShorty.new(container)
    end
    container.register(:find_shorty, memoize: true) do
      Interactors::FindShorty.new(container)
    end
    container.register(:find_shorty_stats, memoize: true) do
      Interactors::FindShortyStats.new(container)
    end
    container.register(:random_generator, memoize: true) do
      SecureRandom
    end

    self.eagerly_initialize(container) if eagerly_initialize
    container
  end

  def config
    @config ||= Config.new
  end

  def eagerly_initialize(container)
    container.each_key do |dependency|
      container.resolve(dependency)
    end
  end
end
