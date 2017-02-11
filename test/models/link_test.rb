require 'test_helper'

class LinkTest < MiniTest::Test
  def test_that_is_valid
    link = Link.new(url: 'http://google.com', shortcode: 'google')
    assert_equal true, link.valid?
  end

  def test_that_url_cant_be_nil
    link = Link.new(url: nil, shortcode: 'google')
    assert_equal false, link.valid?
  end

  def test_that_url_cant_be_blank
    link = Link.new(url: '', shortcode: 'google')
    assert_equal false, link.valid?
  end

  def test_that_url_is_valid
    link = Link.new(url: 'google', shortcode: 'google')
    assert_equal false, link.valid?
  end

  def test_that_generates_a_random_shortcode
    link = Link.new(url: 'http://google.com')
    assert_equal true, link.valid?
    assert_equal 6, link.shortcode.length
  end

  def test_that_shortcode_cant_be_blank
    link = Link.new(url: 'http://google.com', shortcode: '')
    assert_equal false, link.valid?
  end

  def test_that_shortcode_is_valid
    link = Link.new(url: 'http://google.com', shortcode: 'googçe')
    assert_equal false, link.valid?
  end

  def test_that_shortcode_is_unique
    Link.create(url: 'http://twitter.com', shortcode: 'twitte')
    link = Link.new(url: 'http://twitter.com/me', shortcode: 'twitte')
    assert_equal false, link.valid?
  end
end
