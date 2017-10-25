require './app/data/repositories/repository'

class Validator

  def self.blank?(value)
    value.nil? || value.empty?
  end

  def self.match?(value)
    !/^[0-9a-zA-Z_]{4,}$/.match(value).nil?
  end

  def self.exists?(value)
    !Repository.for(:shortme).get(value).nil?
  end
end
