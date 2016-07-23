module Routes
  class Base < Cuba
    define do
      on get, root do
        format_json({ message: "Hello World" })
      end
    end
  end
end
