module Shorty
  class API < Grape::API
    version 'v1', using: :header
    format :json
  end
end
