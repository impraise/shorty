# coding: utf-8
require 'sinatra'
require 'json'

set :bind, '0.0.0.0'

before do
  content_type :json, charset: 'utf-8'
end

get '/' do
  {message: "Meus parabéns"}.to_json
end
