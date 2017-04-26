class Shorty
  @config = {}

  class << self
    attr_accessor :config
  end
end

class UndefinedUrl < StandardError; end
class MalformedUrl < StandardError; end
class DuplicateShortcode < StandardError; end
class MalformedShortcode < StandardError; end
class ShortcodeNotFound < StandardError; end
