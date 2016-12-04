#!/usr/bin/env ruby

require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require 'rack/test/json'

#!/usr/bin/env ruby

require_relative 'app'

class ShortyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def post_json(path, data)
    post path, JSON.dump(data), { "CONTENT_TYPE" => "application/json" }
  end

  def app
    ShortyApp.new
  end

  def test_it_fails_if_no_url
    post_json '/shorten', {}
    assert last_response.bad_request?

    post_json '/shorten', {url: ''}
    assert last_response.bad_request?
  end

  def test_it_fails_on_invalid_shortcode
    post_json '/shorten', {
                url: 'http://google.com',
                shortcode: 'go+og'
              }
    assert last_response.unprocessable?
  end

  def test_around_google
    get '/google'
    assert last_response.not_found?

    get '/google/stats'
    assert last_response.not_found?

    post_json '/shorten', {
                url: 'https://google.com',
                shortcode: 'google'
              }
    assert last_response.created?
    assert last_response.json?
    assert_equal 'google', last_response.as_json['shortcode']

    post_json '/shorten', {
                url: 'https://google.com',
                shortcode: 'google'
              }
    assert last_response.client_error?
    assert_equal 409, last_response.status

    get '/google'
    assert last_response.redirect?
    assert_equal 'https://google.com', last_response.location

    get '/google/stats'
    assert last_response.ok?
    assert last_response.json?
    assert_equal 1, last_response.as_json['redirectCount']
    startDate = Time.parse(last_response.as_json['startDate'])
    lastSeenDate = Time.parse(last_response.as_json['lastSeenDate'])
    assert Time.now >= startDate
    assert Time.now >= lastSeenDate
    assert startDate <= lastSeenDate
  end

  def test_around_yandex
    post_json '/shorten', {
                url: 'https://yandex.com',
              }
    assert last_response.created?
    assert last_response.json?
    assert last_response.as_json['shortcode'] =~ /^[0-9a-zA-Z_]{6}$/

    yandex_code = last_response.as_json['shortcode']

    post_json '/shorten', {
                url: 'https://yandex.com',
                shortcode: yandex_code
              }
    assert last_response.client_error?
    assert_equal 409, last_response.status

    get "/#{yandex_code}"
    assert last_response.redirect?
    assert_equal 'https://yandex.com', last_response.location

    get "/#{yandex_code}"
    assert last_response.redirect?
    assert_equal 'https://yandex.com', last_response.location

    get "/#{yandex_code}/stats"
    assert last_response.ok?
    assert last_response.json?
    assert_equal 2, last_response.as_json['redirectCount']
    startDate = Time.parse(last_response.as_json['startDate'])
    lastSeenDate = Time.parse(last_response.as_json['lastSeenDate'])
    assert Time.now >= startDate
    assert Time.now >= lastSeenDate
    assert startDate <= lastSeenDate
  end
end
