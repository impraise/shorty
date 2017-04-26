# = ShortyController
#
# For now it only holds the app configuration
class Shorty
  @config = {}

  class << self
    attr_reader :config

    def call(env)
      request = Rack::Request.new(env)

      controller = ShortyController.new(request)

      case request.path
      when '/shorten'
        controller.shorten
      when %r(^\/([0-9a-zA-Z_]{4,})\/stats$)
        controller.stats Regexp.last_match(1).to_s
      when %r(^\/([0-9a-zA-Z_]{4,})$)
        controller.go Regexp.last_match(1).to_s
      else
        raise ShortcodeNotFound
      end
    rescue StandardError => ex
      controller.error(ex)
    end
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
