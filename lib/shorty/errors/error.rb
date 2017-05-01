module Shorty
  module Errors
    Error = Class.new(StandardError)
    ShortyNotFoundError = Class.new(Error)
    ShortcodeAlreadyExistsError = Class.new(Error)
    ShortcodeMalformedError = Class.new(Error)
  end
end
