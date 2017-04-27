defmodule Shorty.Repositories.Code do
  alias Shorty.Code

  def find_by_shortcode(shortcode) do
    Code |> Shorty.Repo.get_by(shortcode: shortcode)
  end

  def update!(code, fields) do
    code
    |> Ecto.Changeset.change(fields)
    |> Shorty.Repo.update!
  end

  def update_hit!(code) do
    code |> update!(%{hits: code.hits + 1})
  end

  def save!(code) do
    code |> Shorty.Repo.insert!
  end
end
