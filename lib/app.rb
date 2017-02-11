require "sinatra"
require "json"

post "/shorten" do
  begin
    parsed_params = JSON.parse(request.body.read.to_s)
  rescue JSON::ParserError
    return 400
  end

  return 400 unless parsed_params && parsed_params["url"]
  if parsed_params["shortcode"]
    return 422 unless parsed_params["shortcode"] =~ EncodedLink::SHORTCODE_REGEX
    return 409 if EncodedLink.where(shortcode: parsed_params["shortcode"]).any?
  end

  encoded_link = EncodedLink.new(parsed_params)
  if encoded_link.save
    status 201
    content_type :json
    { shortcode: encoded_link.shortcode }.to_json
  end
end

get "/:shortcode" do
  result = EncodedLink.where(shortcode: params["shortcode"]).first
  return 404 unless result

  LinkAccess.create!(encoded_link: result)
  redirect result.url, 302
end

get "/:shortcode/stats" do
  result = EncodedLink.where(shortcode: params["shortcode"]).first
  return 404 unless result

  content_type :json
  result.stats.to_json
end
