defmodule Shorty.Interactors.CreateShortcode do
  alias Shorty.Repositories.Code, as: CodeRepo
  alias Shorty.Code

  def call(%{shortcode: shortcode, url: url}) do
    if is_nil(shortcode) do
      shortcode = generate_random_string()
    end

    case CodeRepo.find_by_shortcode(shortcode) do
      %Code{} -> {:error, :conflict}
      _       -> create(shortcode, url)
    end
  end

  defp create(shortcode, url) do
    changeset = %Code{} |> Code.changeset(%{shortcode: shortcode, url: url})

    if changeset.valid? do
      code = changeset |> CodeRepo.save!
      {:ok, code}
    else
      {:error, :unprocessable_entity}
    end
  end

  defp generate_random_string do
    :crypto.strong_rand_bytes(6)
    |> Base.url_encode64
    |> binary_part(0, 6)
    |> String.replace("-", "_")
  end
end
