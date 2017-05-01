defmodule Shorty.Interactors.UpdateCodeHitsTest do
  use Shorty.ModelCase
  import Mock

  alias Shorty.Code
  alias Shorty.Interactors.UpdateCodeHits

  test "call does not update when the shortcode does not exist" do
    with_mock Shorty.Repositories.Code, [find_by_shortcode: fn("unknown") -> nil end] do
      assert {:error, _} = UpdateCodeHits.call(%{shortcode: "unknown"})
    end
  end

  test "call updates the hit counter for given shortcode" do
    code = %Code{
      id: "507f1f77bcf86cd799439011",
      url: "https://google.com",
      shortcode: "123456",
      hits: 0,
    }

    with_mock Shorty.Repositories.Code, [
      find_by_shortcode: fn("123456") -> code end,
      update_hit!: fn(code) -> %{code | hits: 1} end
    ] do
      assert {:ok, %Code{shortcode: "123456", hits: 1}} = UpdateCodeHits.call(%{shortcode: "123456"})
    end
  end
end
