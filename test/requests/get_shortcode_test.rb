require 'test_helper'

class GetShorcodeTest < MiniTest::Test
  def test_returns_302
    link = Link.create(url: 'http://google.com', shortcode: 'google')
    header 'Content-Type', 'application/json'
    get '/google'
    assert_equal 302, last_response.status
    assert_equal 'http://google.com', last_response.headers['Location']
    assert_equal 1, link.reload.clicks.count
  end

  def test_returns_404
    header 'Content-Type', 'application/json'
    get '/google'
    assert_equal 404, last_response.status
  end
end
