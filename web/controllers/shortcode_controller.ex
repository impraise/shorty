defmodule Shorty.ShortcodeController do
  use Shorty.Web, :controller

  alias Shorty.Interactors.UpdateCodeHits
  alias Shorty.Interactors.GetCode

  def index(conn, %{"shortcode" => shortcode}) do
    case UpdateCodeHits.call(%{shortcode: shortcode}) do
      {:ok, code} ->
        conn
        |> put_resp_header("location", code.url)
        |> resp(:found, "")
        |> halt
      {:error, _} ->
        conn
        |> resp(:not_found, "")
        |> halt
    end
  end

  def stats(conn, %{"shortcode" => shortcode}) do
    case GetCode.call(%{shortcode: shortcode}) do
      {:ok, code} ->
        render conn, "stats.json", code

      {:error, _} ->
        conn
        |> resp(:not_found, "")
        |> halt
      end
    end
end
