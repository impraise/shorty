defmodule Shorty.Interactors.CreateShortcode do
  alias Shorty.Repositories.Code, as: CodeRepo
  alias Shorty.Code

  def call(%{shortcode: shortcode, url: url}) when is_nil(shortcode) do
    call(%{shortcode: Code.generate_random_shortcode(), url: url})
  end

  def call(%{shortcode: shortcode, url: url}) do
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
end
