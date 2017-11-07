module Api::V1::Concerns::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing do |e|
      json_response(e.message, :bad_request)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response(e.message, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      status = :unprocessable_entity if e.message.include?('is invalid')
      status = :conflict if e.message.include?('been taken')
      status = :bad_request if e.message.include?("can't be blank")
      json_response(e.message, status)
    end
  end
end
