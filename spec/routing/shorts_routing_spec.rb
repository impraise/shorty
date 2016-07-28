require "rails_helper"

RSpec.describe ShortsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/shorten").to route_to("shorts#create")
    end

    it "routes to #show" do
      expect(get: "/shortcode").to route_to("shorts#show", shortcode: "shortcode")
    end

    it "routes to #stats" do
      expect(get: "/shortcode/stats").to route_to("shorts#stats", shortcode: "shortcode")
    end
  end
end
