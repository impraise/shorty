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
    |> validate_required([:url])
    |> validate_format(:shortcode, ~r/^[0-9a-zA-Z_]{4,}$/)
  end

  def generate_random_shortcode do
    :crypto.strong_rand_bytes(6)
    |> Base.url_encode64
    |> binary_part(0, 6)
    |> String.replace("-", "_")
  end
end
