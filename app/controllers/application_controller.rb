class ApplicationController < ActionController::API
  private

  def render_error(e, status: 500)
    body = { error: { message: e.message }, status: status }

    render json: body, status: status
  end
end
