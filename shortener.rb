require 'grape'
require 'mongo'
require 'pry'
require_relative 'app/shortcoder_service.rb'

class Shortener < Grape::API
  API_ERRORS = {
    400 => 'url is not present',
    404 => 'The shortcode cannot be found in the system',
    409 => 'The the desired shortcode is already in use. Shortcodes are case-sensitive.',
    422 => 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'
  }

  # Helper methods
  helpers do
    def send_error(error_code)
      error!(API_ERRORS[error_code], error_code)
    end

    def shortcoder
      @shortcoder ||= ShortcoderService.new
    end
  end

  content_type :json, 'application/json'
  default_format :json

  # POST /shorten
  post :shorten do
    pref_code = params[:shortcode]

    return send_error(400) unless params[:url]

    if pref_code && shortcoder.code_present?(pref_code)
      send_error(409)
    elsif pref_code && !shortcoder.code_valid?(pref_code)
      send_error(422)
    else
      gen_code = shortcoder.create_code(pref_code, params[:url])
      { 'shortcode': gen_code.to_s }
    end
  end

  # GET /:shortcode
  get '/:shortcode' do
    response = shortcoder.get_url_by(params[:shortcode])

    if response == '404'
      send_error(404)
    else
      redirect response
    end
  end

  # GET /:shortcode/stats
  get '/:shortcode/stats' do
    response = shortcoder.get_stats_for(params[:shortcode])
    response == '404' ? send_error(404) : response
  end
end
