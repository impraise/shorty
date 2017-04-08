require 'grape'
require_relative '../lib/shortcode_model'

module Api
  class Shortener < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    content_type :json, 'application/json'
    default_format :json

    desc 'A random shortcode is generated if none is requested'
    params do
      requires :url, type: String, desc: 'url to shorten'
      optional :shortcode, type: String, desc: 'preferential shortcode'
    end
    post :shorten do
      shortcode = params[:shortcode].try :downcase
      if shortcode
        pattern = /^[0-9a-zA-Z_]{4,}$/
        if ShortcodeModel.find_shortcode(shortcode)
          error!('The desired shortcode is already in use', 409)
        elsif shortcode !~ pattern
          error!("The shortcode fails to meet the following regexp: #{pattern}", 422)
        end
      end
      shortcode = ShortcodeModel.add_shortcode(shortcode, params[:url])

      { shortcode: shortcode }
    end

    desc 'Redirects to the url'
    params do
      requires :shortcode, type: String, desc: 'url encoded shortcode'
    end
    get '/:shortcode' do
      shortcode = ShortcodeModel.find_shortcode(params[:shortcode])
      if shortcode
        url = ShortcodeModel.use_shortcode(params[:shortcode])
        redirect url
      else
        error!('The shortcode cannot be found in the system', 404)
      end
    end

    desc 'Get shortcode stats'
    params do
      requires :shortcode, type: String, desc: 'url encoded shortcode'
    end
    get '/:shortcode/stats' do
      shortcode = ShortcodeModel.find_shortcode(params[:shortcode])
      if shortcode
        shortcode = JSON.parse shortcode
        response = {
          startDate: shortcode['start_date'],
          redirectCount: shortcode['redirect_count']
        }
        if shortcode['redirect_count'] > 0
          response[:lastSeenDate] = shortcode['last_seen_date']
        end
        response
      else
        error!('The shortcode cannot be found in the system', 404)
      end
    end
  end
end
