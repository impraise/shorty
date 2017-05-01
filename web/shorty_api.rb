require 'grape'
require 'shorty/errors/error'
require 'validators/shortcode_validator'
require 'entities/shorty'

module Shorty
  class ShortyApi < Grape::API
    resource :shorten do
      desc 'Create a shorty'
      params do
        requires :url, type: String, allow_blank: false, fail_fast: true, message: 'is not present'
        optional :shortcode, shortcode: ::Shorty.config[:valid_shortcode_regex], fail_fast: true
      end
      post do
        present System[:create_shorty].call(url: params[:url], shortcode: params[:shortcode]), with: Entities::ShortyCode
      end
    end

    resource ':shortcode' do
      desc 'Get shorty redirect'
      params do
        requires :shortcode
      end
      get do
        redirect System[:find_shorty].call(shortcode: params[:shortcode]).url
      end

      desc 'Get shorty stats'
      params do
        requires :shortcode
      end
      get :stats do
        present System[:find_shorty_stats].call(shortcode: params[:shortcode]), with: Entities::Shorty
      end
    end
  end
end
