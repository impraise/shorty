require 'sinatra/json'

class API < Sinatra::Application
  before do
    content_type 'application/json'
  end

  helpers do
    def shortcode_or_404
      Shortcode.first(shortcode: params['shortcode']) || halt(404)
    end
  end

  post '/shorten' do
    halt 400 unless params['url']
    halt 409 if Shortcode.first(shortcode: params['shortcode'])

    shortcode = Shortcode.new(
      'shortcode' => params['shortcode'],
      'url' => params['url']
    )

    halt 422 unless shortcode.conforms?

    shortcode.save

    status 201
    json({
      'shortcode': shortcode.shortcode
    })
  end

  get '/:shortcode' do
    shortcode = shortcode_or_404
    shortcode.increment!
    redirect to(shortcode.url)
  end

  get '/:shortcode/stats' do
    shortcode = shortcode_or_404
    json({
      'startDate' => shortcode.created_at.iso8601,
      'lastSeenDate' => shortcode.updated_at.iso8601,
      'redirectCount' => shortcode.redirect_count
    })
  end
end
