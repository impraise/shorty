module Shorty
  class GetShortcodeStats < Grape::API
    resource ':shortcode' do
      desc 'Return shortcode stats.'
      
      get '/stats' do
        shortened_url = ShortenedUrl[shortcode: params[:shortcode]]
        raise Shorty::Errors::NotFoundShortcodeError.new unless shortened_url
        
        stats = { 
          'startDate'     => shortened_url.start_date,
          'redirectCount' => shortened_url.redirect_count,
        }
        stats['lastSeenDate'] = shortened_url.last_seen_date if shortened_url.redirect_count > 0
        
        stats
      end
    end
  end
end