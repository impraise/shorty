module Shorty
  class API < Grape::API
    version 'v1', using: :accept_version_header

    mount Shorty::Shorten
  end
end
 