defmodule Shorty.ShortenController do
  use Shorty.Web, :controller

  alias Shorty.Interactors.CreateShortcode

  def create(conn, %{"shortcode" => _, "url" => nil}), do: conn |> resp(:bad_request, "") |> halt
  def create(conn, %{"shortcode" => shortcode, "url" => url}) do
    result = CreateShortcode.call(%{shortcode: shortcode, url: url})

    case result do
      {:ok, code} ->
        render conn, "create.json", code

      {:error, status_code} ->
        conn
        |> resp(status_code, "")
        |> halt
    end
  end
end
