defmodule Shorty.Interactors.UpdateCodeHits do
  alias Shorty.Repositories.Code, as: CodeRepo

  def call(%{shortcode: shortcode}) do
    code = shortcode |> CodeRepo.find_by_shortcode |> CodeRepo.update_hit!

    {:ok, code}
  end
end
