defmodule Shorty.ErrorView do
  use Shorty.Web, :view

  def render("500.json", _), do: "Internal Server Error"
  def render("500.html", _), do: "Internal Server Error"
  def render("404.json", _), do: "Page not found"
  def render("400.json", _), do: "Bad request"
  def render("404.html", _), do: "Page not found"
end
