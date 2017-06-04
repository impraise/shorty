module Shorty
  class Shorten < Grape::API
    format :json
    
    resource :shorten do
      desc 'Creates a shorten url.'
      get "/" do
        { success: true }
      end
    end
  end
end
 