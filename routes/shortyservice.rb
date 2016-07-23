module Routes
  class Base < Cuba
    define do
      on get, root do
        res.write "Hello World"
      end
    end
  end
end
