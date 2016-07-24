require_relative "../test_helper"

describe "Validators::ShortenURL" do
  before do
    @valid_attributes = {
      url: "http://threefunkymonkeys.com",
      shortcode: SecureRandom.hex(3)
    }

    @context = Routes::Base.new
  end

  it "Should respond created if shortened" do
    @context.redis.expects(:call).with("SET", @valid_attributes[:shortcode], @valid_attributes[:url]).returns("OK")
    @context.expects(:created!).with({ shortcode: @valid_attributes[:shortcode] })
    
    Concerns::ShortenURL.new(attributes: @valid_attributes, context: @context).execute
  end

  it "Should respond with error if not shortened" do
    @context.redis.expects(:call).with("SET", @valid_attributes[:shortcode], @valid_attributes[:url]).returns(nil)
    @context.expects(:server_error!)

    Concerns::ShortenURL.new(attributes: @valid_attributes, context: @context).execute
  end
end
