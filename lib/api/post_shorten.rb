module Shorty
  class PostShorten < Grape::API
    resource :shorten do
      desc 'Creates a shorten url.'
      
      params do
        requires :url, type: String
        optional :shortcode, type: String
      end
      
      post "/" do
        service = CreateShortenedUrlService.new(declared(params))
        shortened_url = service.perform

        present shortened_url, with: Shorty::Entities::ShortenedUrlEntity
      end
    end
  end
end
 