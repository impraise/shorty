defmodule Shorty.ShortcodeView do
  use Shorty.Web, :view

  alias Shorty.Code

  def render("stats.json", code), do: representer(code)

  defp representer(%Code{hits: 0} = code), do: %{"startDate" => code.inserted_at, "redirectCount" => code.hits}
  defp representer(%Code{} = code), do: %{"startDate" => code.inserted_at, "redirectCount" => code.hits, "lastSeenDate" => code.updated_at}
end
