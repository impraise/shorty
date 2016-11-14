class API < Sinatra::Application
  before do
    content_type 'application/json'
  end

  helpers do
    def shortcode_taken?
      params['shortcode'] && Shortcode.first(shortcode: params['shortcode'])
    end

    def shortcode_or_404
      Shortcode.first(shortcode: params['shortcode']) || halt(404)
    end
  end

  post '/shorten' do
    halt 400 unless params['url']
    halt 409 if shortcode_taken?

    params.keep_if{|k,v| ['shortcode', 'url'].include?(k) }

    shortcode = Shortcode.new(params)

    if shortcode.save
      status 201
      { 'shortcode' => shortcode.shortcode }.to_json
    else
      halt 400 unless shortcode.errors[:url].empty?
      halt 409 unless shortcode.shortcode   # random generation failed
      halt 422 unless shortcode.errors[:shortcode].empty?
      halt 500
    end
  end

  get '/:shortcode' do
    shortcode = shortcode_or_404
    shortcode.increment!
    redirect to(shortcode.url)
  end

  get '/:shortcode/stats' do
    shortcode = shortcode_or_404

    response = {
      'startDate' => shortcode.created_at.iso8601,
      'lastSeenDate' => shortcode.updated_at.iso8601,
      'redirectCount' => shortcode.redirect_count
    }
    response.delete('lastSeenDate') if shortcode.redirect_count == 0
    response.to_json
  end
end
