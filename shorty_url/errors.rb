module ShortyUrl
  class Error < StandardError
  end

  class ShortCodeAlreadyInUseError < Error
  end
end
