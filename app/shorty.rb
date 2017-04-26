# = ShortyController
#
# For now it only holds the app configuration
class Shorty
  @config = {}

  class << self
    attr_reader :config
  end
end

# Define the global app exceptions.
# I'm against this kind of flow contol, but that's the way
# Sinatra do things, so following the convention.

# = UndefinedUrl
class UndefinedUrl < StandardError; end
# = MalformedUrl
class MalformedUrl < StandardError; end
# = DuplicateShortcode
class DuplicateShortcode < StandardError; end
# = MalformedShortcode
class MalformedShortcode < StandardError; end
# = ShortcodeNotFound
class ShortcodeNotFound < StandardError; end
