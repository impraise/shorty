module Shorty
  class GetShortcodeStats < Grape::API
    resource ':shortcode' do
      desc 'Return shortcode stats.'
      
      get '/stats' do
        shortened_url = ShortenedUrl[shortcode: params[:shortcode]]
        raise Shorty::Errors::NotFoundShortcodeError.new unless shortened_url
        
        present shortened_url, with: Shorty::Entities::ShortenedUrlEntity, stats: true
      end
    end
  end
end