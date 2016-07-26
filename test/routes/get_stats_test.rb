require_relative "../test_helper"

describe "GET /:shortcode/stats" do
  it "Should not show last seen with no views" do
    url = ShortURL.create(shortcode: "mycode", url: "http://myurl.com")

    json_get "/mycode/stats"

    body = JSON.parse(last_response.body)

    assert_equal 200, last_response.status

    assert_equal Time.at(url.created_at).iso8601, body["startDate"]
    assert_equal 0, body["redirectCount"]

    assert !body.key?("lastSeenDate")
  end

  it "Should show last seen with at least 1 view" do
    url = ShortURL.create(shortcode: "mycode", url: "http://myurl.com")
    url.register_view

    json_get "/mycode/stats"

    body = JSON.parse(last_response.body)

    assert_equal 200, last_response.status

    assert_equal Time.at(url.created_at).iso8601, body["startDate"]
    assert_equal Time.at(url.last_seen).iso8601, body["lastSeenDate"]
    assert_equal 1, body["redirectCount"]
  end

  it "Should return 404 Not Found (code not in the system)" do
    Redis.client.call "DEL", "mycode" #Make sure the code is not stored

    json_get "/mycode/stats"

    response = JSON.parse(last_response.body)

    assert_equal 404, last_response.status
    assert_equal "The shortcode cannot be found in the system", response["description"]
  end
end
