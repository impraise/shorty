module Api::V1::Concerns::Response

  # returns a JSON object with an http status code and location headers
  def json_response(object = nil, status = :ok, location = nil)
    @object = object
    render status: status, location: location
  end
end
