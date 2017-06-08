class ApplicationController
  def self.build_response(status:, body:, content_type:)
    OpenStruct.new({status: status, body: body, content_type: content_type})
  end

  def self.json_response(status:, body:)
    build_response(status: status, body: body, content_type: :json)
  end
end
