require 'rails_helper'

describe ShortenUrlController do
  it 'routes to /shorten via POST' do
    expect(post: '/shorten').to route_to('shorten_url#create')
  end

  it 'routes to /:shortcode via GET' do
    expect(get: '/myShortCode').to route_to(controller: 'shorten_url', action: 'show', shortcode: 'myShortCode')
  end

  it 'routes to /:shortcode/stats via GET' do
    expect(get: '/myShortCode/stats').to route_to(controller: 'shorten_url', action: 'stats', shortcode: 'myShortCode')
  end
end
