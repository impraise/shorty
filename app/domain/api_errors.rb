module ApiErrors
  Error = Class.new(StandardError)
  UrlNotPresent = Class.new(Error)
  CodeTaken = Class.new(Error)
  InvalidCode = Class.new(Error)
end
