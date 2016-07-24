module Routes
  class Base < Cuba
    define do
      on get do
        on ":shortcode" do |shortcode|
          url = redis.call("GET", shortcode)

          not_found! unless url

          redirect!(url)
        end
      end

      on post do
        on "shorten" do
          params = parse_request

          validator = Validators::ShortenURL.new(params)

          error_response!(validator.errors) unless validator.valid?

          Concerns::ShortenURL.new(attributes: validator.attributes, context: self).execute
        end
      end
    end
  end
end
