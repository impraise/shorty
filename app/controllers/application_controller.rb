class ApplicationController < ActionController::Base
  include Api::V1::Concerns::Response
  include Api::V1::Concerns::ExceptionHandler
end
