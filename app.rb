require 'sinatra/base'
require './config/config'
require './app/presenters/shorten_presenter'
require './app/data/repositories/repository'
require './app/data/repositories/short_me_repository'
require './app/error_handler'

class App < Sinatra::Base
    register Sinatra::Config
    register Sinatra::ShortenPresenter
    register Sinatra::ErrorHandler

    Repository::register(:shortme, ShortMeRepository.new)
end
