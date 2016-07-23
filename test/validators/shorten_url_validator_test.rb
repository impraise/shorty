require_relative "../test_helper"

describe "Validators::ShortenURL" do
  before do
    @valid_attributes = {
      url: "http://threefunkymonkeys.com",
      shortcode: SecureRandom.hex(3)
    }

    @redis = Redis.client
  end

  it "Should be valid" do
    action = Validators::ShortenURL.new(@valid_attributes)

    assert action.valid?
  end

  it "Should not be valid (url not present)" do
    @valid_attributes.delete(:url)

    action = Validators::ShortenURL.new(@valid_attributes)

    assert !action.valid?
    assert_equal [:not_present], action.errors[:url]
  end

  it "Should not be valid (shortcode not valid)" do
    @valid_attributes[:shortcode] = "long-inv4li#dc0d@"

    action = Validators::ShortenURL.new(@valid_attributes)

    assert !action.valid?
    assert_equal [:format], action.errors[:shortcode]
  end

  it "Should not be valid (shortcode not unique)" do
    @redis.call "SET", @valid_attributes[:shortcode], "http://impraise.com"

    action = Validators::ShortenURL.new(@valid_attributes)

    assert !action.valid?
    assert_equal [:not_unique], action.errors[:shortcode]
  end
end

