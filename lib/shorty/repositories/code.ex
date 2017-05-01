defmodule Shorty.Repositories.Code do
  alias Shorty.Code
  alias Shorty.Repo
  alias Ecto.Multi

  def find_by_shortcode(shortcode) do
    Code |> Repo.get_by(shortcode: shortcode)
  end

  def update_hit!(code) do
    code |> update!(%{hits: code.hits + 1})
  end

  def update!(code, fields) do
    {:ok, %{code: code}} =
      Multi.new
      |> Multi.update(:code, Ecto.Changeset.change(code, fields))
      |> Repo.transaction

    code
  end

  def save!(code) do
    {:ok, %{code: code}} =
      Multi.new
      |> Multi.insert(:code, code)
      |> Repo.transaction

    code
  end
end
