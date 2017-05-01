defmodule Shorty.Interactors.UpdateCodeHits do
  alias Shorty.Repositories.Code, as: CodeRepo
  alias Shorty.Code

  def call(%{shortcode: shortcode}) do
    case shortcode |> CodeRepo.find_by_shortcode do
      code = %Code{} -> {:ok, code |> CodeRepo.update_hit!}
      _              -> {:error, "Does not exist"}
    end
  end
end
