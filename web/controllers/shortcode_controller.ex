defmodule Shorty.ShortcodeController do
  use Shorty.Web, :controller

  alias Shorty.Interactors.UpdateCodeHits
  alias Shorty.Interactors.GetCode

  def index(conn, %{"shortcode" => shortcode}) do
    case UpdateCodeHits.call(%{shortcode: shortcode}) do
      {:ok, code} -> redirect_to(conn, code.url)
      {:error, _} -> not_found(conn)
    end
  end

  def stats(conn, %{"shortcode" => shortcode}) do
    case GetCode.call(%{shortcode: shortcode}) do
      {:ok, code} -> render conn, "stats.json", code
      {:error, _} -> not_found(conn)
    end
  end

  defp redirect_to(conn, url), do: conn |> put_resp_header("location", url) |> resp(:found, "") |> halt
  defp not_found(conn), do: conn |> resp(:not_found, "") |> halt
end
