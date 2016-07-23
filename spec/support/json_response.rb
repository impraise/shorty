module JsonResponse
  def json_response
    subject unless response.sent?
    JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError
    puts 'JSON parsing failed. Raw response body:'
    puts response.body
  end
end
