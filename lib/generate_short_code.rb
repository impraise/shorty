class GenerateShortCode
  CHARS = [*('A'..'Z'), *('a'..'z'), *(0..9), '_'].freeze

  def call(length = 6)
    chars_size = CHARS.size
    (0...length).map { CHARS[rand(chars_size)] }.join
  end
end
