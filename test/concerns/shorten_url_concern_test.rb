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
    @context.expects(:created!).with({ shortcode: @valid_attributes[:shortcode] })
    
    Concerns::ShortenURL.new(attributes: @valid_attributes, context: @context).execute
  end

  it "Should respond with error if not shortened" do
    ShortURL.expects(:create).with(url: @valid_attributes[:url], shortcode: @valid_attributes[:shortcode]).returns(nil)

    @context.expects(:server_error!)

    Concerns::ShortenURL.new(attributes: @valid_attributes, context: @context).execute
  end
end
