require 'shorty/entities/shorty'

module Support
  module Shorties
    module_function

    def existing_shorty
      Shorty::Shorty.new(url: 'url1', shortcode: 'shortcode1')
    end

    def new_shorty
      Shorty::Shorty.new(url: 'url2', shortcode: 'shortcode2')
    end
  end
end
