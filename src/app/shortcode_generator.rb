class ShortcodeGenerator
  CHAR_OPTIONS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a.map(&:to_s) + ['_']

  def self.random_char
    CHAR_OPTIONS[rand(CHAR_OPTIONS.size)]
  end

  def self.random_shortcode
    (0..5).map { random_char }.join
  end
end
