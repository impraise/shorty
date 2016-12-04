require 'json'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'helpers'

ALLOWED_SHORTCODE_RE = '[0-9a-zA-Z_]{4,}'

class ShortyApp < Sinatra::Base
  post '/shorten' do
    request.body.rewind
    data = JSON.parse(request.body.read)

    url = data['url']
    if url.nil? || url.empty?
      halt 400
    end

    code = data['shortcode']
    if !code.nil? && !code.empty?
      if code !~ /^#{ALLOWED_SHORTCODE_RE}$/
        halt 422
      end

      if !Link.get(code).nil?
        halt 409
      end
    else
      loop {
        code = generate_code()
        if Link.get(code).nil?
          break
        end
      }
    end

    # XXX: By some reasons created_at is not set automatically when I use !-functions.
    link = Link.create!(shortcode: code, url: url, created_at: Time.now)

    resp = {shortcode: code}

    status 201
    json resp
  end

  get %r{/(?<shortcode>#{ALLOWED_SHORTCODE_RE})/stats$} do
    code = params[:shortcode]

    link = Link.get(code)
    if !link
      halt 404
    end

    status 200
    json link.as_json
  end

  get %r{/(?<shortcode>#{ALLOWED_SHORTCODE_RE})$} do
    code = params[:shortcode]

    link = Link.get(code)
    if !link
      halt 404
    end

    link.seen!
    link.save!

    redirect link.url
  end
end
