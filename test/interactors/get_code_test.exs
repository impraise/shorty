defmodule Shorty.Interactors.GetCodeTest do
  use Shorty.ModelCase
  import Mock

  alias Shorty.Interactors.GetCode

  @code %Shorty.Code{
    id: "507f1f77bcf86cd799439011",
    url: "https://google.com",
    shortcode: "123456",
    hits: 0,
  }

  test "call fetches an existing code" do
    with_mock Shorty.Repositories.Code, [find_by_shortcode: fn("123456") -> @code end] do
      assert {:ok, @code} = GetCode.call(%{shortcode: "123456"})
    end
  end

  test "call does not fetch an inexistent code" do
    with_mock Shorty.Repositories.Code, [find_by_shortcode: fn("unknown") -> nil end] do
      assert {:error, _} = GetCode.call(%{shortcode: "unknown"})
    end
  end
end
