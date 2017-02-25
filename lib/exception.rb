module ShortyException

  class MissingParameterError < StandardError
  end

  class FormatException < StandardError
  end

  class RecordNotUnique < StandardError
  end

end
