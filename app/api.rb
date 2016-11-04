class API < Sinatra::Application
  before do
    content_type 'application/json'
  end

  helpers do
    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message: 'Invalid JSON' }.to_json
      end
    end
  end

  post '/shorten' do
  end

  get '/:shortcode' do
  end

  get '/:shortcode/stats' do
  end
end
