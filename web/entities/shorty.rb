require 'grape-entity'

module Shorty
  module Entities
    class Shorty < Grape::Entity
      format_with(:iso_timestamp, &:iso8601)

      expose :access_count, as: :redirectCount

      with_options(format_with: :iso_timestamp) do
        expose :created_at, as: :startDate
        expose :updated_at, as: :lastSeenDate, unless: lambda { |shorty, _|
          shorty[:access_count].zero?
        }
      end
    end

    class ShortyCode < Grape::Entity
      expose :shortcode
    end
  end
end
