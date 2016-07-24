require_relative "../test_helper"

describe "GET /:shortcode" do
  it "Should redirect to the stored path" do
    Redis.client.call "SET", "mycode", "http://myurl.com"

    json_get "/mycode"

    assert_equal 302, last_response.status
    assert_equal "http://myurl.com", last_response.headers["Location"]
  end

  it "Should return 404 Not Found (code not in the system)" do
    Redis.client.call "DEL", "mycode" #Make sure the code is not stored

    json_get "/mycode"

    response = JSON.parse(last_response.body)

    assert_equal 404, last_response.status
    assert_equal "The shortcode cannot be found in the system", response["description"]
  end
end
