module ShortyUrl
  class API < Grape::API
    class V1 < Grape::API
      format :json
      content_type :json, 'application/json'

      params do
        requires :url, type: String, desc: 'URL'
        optional :shortcode,
                 type: String,
                 desc: 'desired shortcode'
      end

      post '/shorten' do
        if params[:shortcode].nil? || params[:shortcode] =~ /^[0-9a-zA-Z_]{4,}$/
          begin
            shortcode = ShortyUrl.shortcode(params[:url], params[:shortcode])
            status 201
            present shortcode: shortcode

          rescue ::ShortyUrl::ShortCodeAlreadyInUseError
            msg = 'The the desired shortcode is already in use. Shortcodes are case-sensitive.'
            error!(msg, 409)
          end
        else
          error!('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$', 422)
        end
      end

      get '/:shortcode', requirements: { shortcode: /[0-9a-zA-Z_]{6}/ } do
        url = ShortyUrl.decode(params[:shortcode])
        if url
          header 'Location', url
          status 302
        else
          error!('The shortcode cannot be found in the system', 404)
        end
      end

      get '/:shortcode/stats' do
        stats = ShortyUrl.stats(params[:shortcode])
        if stats
          present :startDate, stats.start_date.iso8601
          present :lastSeenDate, stats.last_seen_date.iso8601 unless stats.redirect_count.zero?
          present :redirectCount, stats.redirect_count
        else
          error!('The shortcode cannot be found in the system', 404)
        end
      end
    end
  end
end
