defmodule Shorty.ShortenView do
  use Shorty.Web, :view

  def render("create.json", code) do
    %{"shortcode" => code.shortcode}
  end
end
