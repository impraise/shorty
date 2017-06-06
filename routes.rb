post '/shorten' do
  response = ShortyController::Create.call(request)
  status response.status
  content_type response.content_type
  response.body
end

get '/:shortcode' do

end

get '/:shortcode/stats' do

end
