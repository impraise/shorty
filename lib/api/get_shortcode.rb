module Shorty
  class GetShortcode < Grape::API
    resource ':shortcode' do
      desc 'Get the url from shortcode and redirect.'
      
      get '/' do
        service = RetrieveShortenedUrlService.new(params[:shortcode])
        shortened_url = service.perform
        
        redirect shortened_url.url
      end
    end
  end
end
 