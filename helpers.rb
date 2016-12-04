require 'securerandom'

def generate_code()
  SecureRandom.base64[0...6].tr('+/=', '_A0')
end
