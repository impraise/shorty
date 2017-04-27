defmodule Shorty.ShortcodeController do
  use Shorty.Web, :controller

  alias Shorty.Interactors.UpdateCodeHits
  alias Shorty.Interactors.GetCode

  def index(conn, %{"shortcode" => shortcode}) do
	{:ok, code} = UpdateCodeHits.call(%{shortcode: shortcode})

	conn
	|> put_resp_header("location", code.url)
	|> resp(:found, "")
	|> halt
  end

  def stats(conn, %{"shortcode" => shortcode}) do
	{:ok, code} = GetCode.call(%{shortcode: shortcode})

    render conn, "stats.json", code
  end
end
