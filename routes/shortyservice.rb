module Routes
  class Base < Cuba
    define do
      on get do
        on ":shortcode" do |shortcode|
          url = ShortURL.fetch(shortcode)

          not_found! unless url

          on root do
            url.register_view
            redirect!(url.url)
          end

          on "stats" do
            success!(stats_for(url))
          end
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
