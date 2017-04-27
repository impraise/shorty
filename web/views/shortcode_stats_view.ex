defmodule Shorty.ShortcodeView do
  use Shorty.Web, :view

  def render("stats.json", code) do
    %{
      "startDate" => code.inserted_at,
      "lastSeenDate" => code.updated_at,
      "redirectCount" => code.hits,
    }
  end
end
