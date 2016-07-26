require_relative "../test_helper"

describe "ShortURL" do
  before do
    @valid_attributes = {
      url: "http://threefunkymonkeys.com",
      shortcode: SecureRandom.hex(3)
    }
  end

  it "Should create an instance with valid attributes" do
    url = ShortURL.create(@valid_attributes)

    assert url
  end

  it "Should store creation date" do
    url = ShortURL.create(@valid_attributes)

    assert url
    assert_equal url.created_at, Redis.client.call("GET", "#{url.shortcode}:created").to_i
  end

  it "Should error without url or shortcode" do
    assert_raises(ArgumentError) do
      ShortURL.create(url: @valid_attributes[:url])
    end

    assert_raises(ArgumentError) do
      ShortURL.create(shortcode: @valid_attributes[:shortcode])
    end
  end

  it "Should start with 0 views" do
    url = ShortURL.create(@valid_attributes)

    assert_equal 0, url.views
  end

  it "Should fetch by shortcode" do
    url = ShortURL.create(@valid_attributes)

    fetched = ShortURL.fetch(url.shortcode)

    assert_equal fetched.shortcode, url.shortcode
    assert_equal fetched.url,       url.url

    assert (fetched != url)
  end

  it "Should fetch nil if code doesn't exist" do
    url = ShortURL.create(@valid_attributes)

    assert !ShortURL.fetch("unknown")
  end

  it "Should delete all data when deleted" do
    url  = ShortURL.create(@valid_attributes)
    code = @valid_attributes[:shortcode]

    url.register_view
    url.delete

    assert !Redis.client.call("GET", code)
    assert !Redis.client.call("GET", "#{code}:created")
    assert !Redis.client.call("GET", "#{code}:views")
  end
end
