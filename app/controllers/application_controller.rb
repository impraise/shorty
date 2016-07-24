class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(error)
    render_error(error, status: 404)
  end

  def render_error(e, status: 500)
    body = { error: { message: e.message }, status: status }

    render json: body, status: status
  end
end
