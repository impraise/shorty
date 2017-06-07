module Shorty
  module Errors
    class ExistingShortcodeError < StandardError
      def initialize
        super('The desired shortcode is already in use. Shortcodes are case-sensitive.')
      end
    end
    
    class InvalidShortcodeError < StandardError
      def initialize
        super('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
      end
    end

    class NotFoundShortcodeError < StandardError
      def initialize
        super('The shortcode cannot be found in the system.')
      end
    end
  end
end