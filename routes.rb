post '/shorten' do
  response = ShortyController::Create.call(request)
  status response.status
  content_type response.content_type
  response.body
end

get '/:shortcode' do
  response = ShortyController::Show.call(params[:shortcode])
  status response.status
  content_type response.content_type
  if response.status == 302
    headers 'Location' => response.body
  else
    response.body
  end
end

get '/:shortcode/stats' do

end
