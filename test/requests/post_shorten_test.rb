require 'test_helper'

class PostShortenTest < MiniTest::Test
  def test_returns_201
    header 'Content-Type', 'application/json'
    params = {
      'url' => 'http://example.com',
      'shortcode' => 'example'
    }
    post '/shorten', Oj.dump(params)
    assert_equal 201, last_response.status
    assert_equal 1, Link.count
    assert_equal Oj.dump({ 'shortcode' => 'example' }), last_response.body
  end

  def test_generates_random_code
    header 'Content-Type', 'application/json'
    params = {
      'url' => 'http://example.com'
    }
    post '/shorten', Oj.dump(params)
    assert_equal 201, last_response.status
    assert_equal 1, Link.count
    assert last_response.body.include?('shortcode')
  end

  def test_returns_400
    header 'Content-Type', 'application/json'
    params = {
      'shortcode' => 'example'
    }
    post '/shorten', Oj.dump(params)
    assert_equal 400, last_response.status
    assert_equal 0, Link.count
  end

  def test_returns_409
    Link.create(url: 'http://example.com', shortcode: 'example')

    header 'Content-Type', 'application/json'
    params = {
      'url' => 'http://example.com',
      'shortcode' => 'example'
    }
    post '/shorten', Oj.dump(params)
    assert_equal 409, last_response.status
    assert_equal 1, Link.count
  end

  def test_returns_422
    header 'Content-Type', 'application/json'
    params = {
      'url' => 'http://example.com',
      'shortcode' => 'exeç'
    }
    post '/shorten', Oj.dump(params)
    assert_equal 422, last_response.status
    assert_equal 0, Link.count
  end
end
