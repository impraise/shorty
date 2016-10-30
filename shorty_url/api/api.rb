require_relative 'errors_helper'
require_relative 'v1'

module ShortyUrl
  class API < Grape::API
    mount V1 => '/'
  end
end
