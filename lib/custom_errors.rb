# frozen_string_literal: true

# Shorty Custom Errors
module CustomErrors
  # Parent CustomError class, has the functionality
  #   of StandardError through inheritence
  class CustomError < StandardError; end

  # Raised when short_code already exists
  class ShortCodeAlreadyInUse < CustomError; end

  # Raised when short_code format is invalid
  class InvalidShortCodeFormat < CustomError; end
end
