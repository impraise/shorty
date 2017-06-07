module Shorty
  module Entities
    class ShortenedUrlStats < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
      expose :redirect_count, as: 'redirectCount'
      
      with_options(format_with: :iso_timestamp) do
        expose :start_date, as: 'startDate'
        expose :last_seen_date, as: 'lastSeenDate', if: lambda { |object, options| 
          object.redirect_count > 0 
        }
      end
    end
  end
end