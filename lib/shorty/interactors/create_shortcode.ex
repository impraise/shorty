defmodule Shorty.Interactors.CreateShortcode do
  alias Shorty.Repositories.Code, as: CodeRepo
  alias Shorty.Code

  def call(%{shortcode: shortcode, url: url}) do
    code = Code.new(shortcode, url) |> CodeRepo.save!

    {:ok, code}
  end
end
