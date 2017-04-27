# = ShortyController
#
# For now it only holds the app configuration
class Shorty
  @config = {}

  # = Route
  #
  # Simple route with built-in matcher
  class Route
    def initialize(method, path, controller, action)
      @method = method
      @path = path
      @controller = controller
      @action = action
      @route_params = []
    end

    def run(request)
      controller = Object.const_get("#{@controller}Controller").new
      controller.run(@action, request, @route_params)
    end

    def match(request)
      @route_params = []

      path = request.path

      if @method == request.request_method
        if @path.is_a? Regexp
          if @path =~ path
            @route_params = Regexp.last_match[1..-1]
            return true
          end
        elsif @path == path
          return true
        end
      end

      false
    end
  end

  # = MatchAllRoute
  #
  # Route that matches everything
  class MatchAllRoute < Route
    def initialize(controller, action)
      @controller = controller
      @action = action
      @route_params = []
    end

    def match(_request)
      true
    end
  end

  class << self
    attr_reader :config

    def routes
      @routes ||= [
        Route.new('POST', '/shorten', 'Shorty', 'shorten'),
        Route.new('GET', %r(^\/([0-9a-zA-Z_]{4,})\/stats$), 'Shorty', 'stats'),
        Route.new('GET', %r(^\/([0-9a-zA-Z_]{4,})$), 'Shorty', 'go'),
        MatchAllRoute.new('Shorty', 'default')
      ]
    end

    def call(env)
      request = Rack::Request.new(env)
      response = [500, {}, Array('Something went wrong.')]

      routes.each do |route|
        next unless route.match(request)

        response = route.run(request)
        break
      end

      response
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
