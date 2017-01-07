require 'grape'
require 'mongo'
require_relative 'lib/shortcoder_service.rb'

class Shortener < Grape::API
  API_ERRORS = {
    400 => 'url is not present',
    404 => 'The shortcode cannot be found in the system',
    409 => 'The the desired shortcode is already in use. Shortcodes are case-sensitive.',
    422 => 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'
  }

  content_type :json, 'application/json'
  default_format :json

  post :shorten do
    pref_code = params[:shortcode]

    return error!(API_ERRORS[400], 400) unless params[:url]

    if pref_code && ShortcoderService.code_present?(pref_code)
      error!(API_ERRORS[409], 409)
    elsif pref_code && !ShortcoderService.code_valid?(pref_code)
      error!(API_ERRORS[422], 422)
    else
      gen_code = ShortcoderService.create_code(pref_code, params[:url])
      { 'shortcode': gen_code.to_s }
    end
  end

  get '/:shortcode' do
    ShortcoderService.get_url_by(params[:shortcode])
  end

  get '/:shortcode/stats' do
  end

  # def send_error(error_code)
  # 	error!(API_ERRORS[error_code], error_code)
  # end
end
