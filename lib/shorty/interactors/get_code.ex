defmodule Shorty.Interactors.GetCode do
  alias Shorty.Repositories.Code, as: CodeRepo
  alias Shorty.Code

  def call(%{shortcode: shortcode}) do
    case CodeRepo.find_by_shortcode(shortcode) do
      code = %Code{} -> {:ok, code}
      _              -> {:error, "Unknown shortcode"}
    end
  end
end
