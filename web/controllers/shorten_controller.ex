defmodule Shorty.ShortenController do
  use Shorty.Web, :controller

  alias Shorty.Interactors.CreateShortcode

  def create(conn, %{"shortcode" => shortcode, "url" => url}) do
    {:ok, code} = CreateShortcode.call(%{
      shortcode: shortcode,
      url: url,
    })

    render conn, "create.json", code
  end
end
