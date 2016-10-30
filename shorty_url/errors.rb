module ShortyUrl
  class Error < StandardError
  end

  class ShortCodeAlreadyInUseError < Error
  end

  class DbParamsAreNotValid < Error
  end
end
