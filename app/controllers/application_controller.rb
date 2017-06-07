class ApplicationController
  def self.build_response(status:, body:, content_type:)
    OpenStruct.new({status: status, body: body, content_type: content_type})
  end
end
