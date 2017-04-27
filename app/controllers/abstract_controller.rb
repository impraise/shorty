require 'json'

class AbstractController
  def run(action, request, params)
    @request = request

    send(action.to_sym, *params)
  rescue StandardError => ex
    error(ex)
  end

  def response(code, message, headers = {})
    headers['Content-Type'] = 'application/json'

    Rack::Response.new(message, code, headers)
  end

  def params
    @request.params
  end

  def json_params
    @json_params ||= JSON.parse(@request.body.read)
  end
end
