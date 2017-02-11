require 'test_helper'

class ClickTest < MiniTest::Test
  def test_that_is_valid
    link = Link.create(url: 'http://google.com', shortcode: 'google')
    click = Click.new(link_id: link.id)
    assert_equal true, click.valid?
  end

  def test_that_url_cant_be_nil
    click = Click.new(link_id: nil)
    assert_equal false, click.valid?
  end

  def test_that_url_cant_be_blank
    click = Click.new(link_id: '')
    assert_equal false, click.valid?
  end
end
