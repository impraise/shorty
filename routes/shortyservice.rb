module Routes
  class Base < Cuba
    define do
      on get, root do
        format_json({ message: "Hello World" })
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
