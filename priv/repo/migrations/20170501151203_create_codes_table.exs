defmodule Shorty.Repo.Migrations.CreateCodesTable do
  use Ecto.Migration

  def change do
    create table(:codes) do
      add :url, :string
      add :shortcode, :string
      add :hits, :integer, default: 0

      timestamps()
    end
  end
end
