defmodule Shorty.Code do
  use Shorty.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "codes" do
    field :shortcode, :string
    field :url, :string
    field :hits, :integer, default: 0

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:shortcode, :url, :hits])
    |> validate_required([:shortcode, :url])
    |> validate_format(:shortcode, ~r/^[0-9a-zA-Z_]{6}$/)
  end
end
