require_relative "../test_helper"

describe "POST /shorten" do
  before do
    @valid_attributes = {
      url: "http://threefunkymonkeys.com",
      shortcode: SecureRandom.hex(3)
    }
  end

  it "Should return 201 Created (with shortcode)" do
    json_post "/shorten", @valid_attributes

    response = JSON.parse(last_response.body)

    assert_equal 201, last_response.status

    assert_equal @valid_attributes[:shortcode], response["shortcode"]
  end

  it "Should return 201 Created (without shortcode)" do
    @valid_attributes.delete(:shortcode)

    json_post "/shorten", @valid_attributes

    response = JSON.parse(last_response.body)

    assert_equal 201, last_response.status
    
    assert !response["shortcode"].empty?
  end

  it "Should return 400 Bad Request (without url)" do
    @valid_attributes.delete(:url)

    json_post "/shorten", @valid_attributes

    response = JSON.parse(last_response.body)

    assert_equal 400, last_response.status

    assert "Bad Request",        response["message"]
    assert "URL is not present", response["description"]
  end

  it "Should return 409 Conflict (shortcode in use)" do
    Redis.client.call "SET", @valid_attributes[:shortcode], "http://impraise.com"

    json_post "/shorten", @valid_attributes

    response = JSON.parse(last_response.body)

    assert_equal 409, last_response.status

    assert "Conflict", response["message"]

    assert "The the desired shortcode is already in use. Shortcodes are case-sensitive", response["description"]
  end

  it "Should return 422 Unprocessable (shortcode in use)" do
    @valid_attributes[:shortcode] = "invali#C*d3"

    json_post "/shorten", @valid_attributes

    response = JSON.parse(last_response.body)

    assert_equal 422, last_response.status

    assert "Unprocessable Entity", response["message"]

    assert "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$", response["description"]
  end
end
