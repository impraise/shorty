require 'test_helper'

class GetShorcodeStatsTest < MiniTest::Test
  def test_returns_200
    link = Link.create(url: 'http://google.com', shortcode: 'google')
    Click.create(link_id: link.id)
    last_click = Click.create(link_id: link.id)
    header 'Content-Type', 'application/json'
    get '/google/stats'
    assert_equal 200, last_response.status
    response_body = Oj.load(last_response.body)
    assert_equal link.start_date, response_body['startDate']
    assert_equal link.last_seen_date, response_body['lastSeenDate']
    assert_equal 2, response_body['redirectCount']
  end

  def test_redirect_count_is_zero
    link = Link.create(url: 'http://google.com', shortcode: 'google')
    header 'Content-Type', 'application/json'
    get '/google/stats'
    assert_equal 200, last_response.status
    response_body = Oj.load(last_response.body)
    assert_equal link.start_date, response_body['startDate']
    assert_nil response_body['lastSeenDate']
    assert_equal 0, response_body['redirectCount']
  end

  def test_returns_404
    header 'Content-Type', 'application/json'
    get '/google/stats'
    assert_equal 404, last_response.status
  end
end
