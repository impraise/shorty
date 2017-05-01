require 'mongoid'

module Shorty
  class ShortiesRepository
    def entity_class
      Shorty
    end

    def create(entity)
      return entity.reload if entity.save
      false
    end

    def find_and_increment_shortcode(shortcode)
      entity = find_by_shortcode shortcode
      return false unless entity

      entity.atomically do |doc|
        doc.inc(access_count: 1)
        doc.set(updated_at: Time.now)
      end

      entity
    end

    def find_by_shortcode(shortcode)
      Shorty.find_by(shortcode: shortcode)
    rescue Mongoid::Errors::DocumentNotFound
      return false
    end
  end
end
