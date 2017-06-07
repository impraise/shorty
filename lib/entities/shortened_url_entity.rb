module Shorty
  module Entities
    class ShortenedUrlEntity < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
      
      expose :shortcode
      expose :redirect_count, as: 'redirectCount', if: { stats: true }
      
      with_options(format_with: :iso_timestamp) do
        expose :start_date, as: 'startDate', if: { stats: true }
        expose :last_seen_date, as: 'lastSeenDate', if: lambda { |object, options| 
          options[:stats] == true && object.redirect_count > 0 
        }
      end
    end
  end
end