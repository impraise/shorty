defmodule Shorty.Interactors.CreateShortcodeTest do
  use Shorty.ModelCase
  import Mock

  alias Shorty.Code
  alias Shorty.Interactors.CreateShortcode

  test "call returns :conflict when trying to create an existing shortcode" do
    code = %Code{
      id: "507f1f77bcf86cd799439011",
      url: "https://google.com",
      shortcode: "123456",
      hits: 0,
    }

    with_mock Shorty.Repositories.Code, [find_by_shortcode: fn("123456") -> code end] do
      assert {:error, :conflict} = CreateShortcode.call(%{shortcode: "123456", url: "https://test.pt"})
    end
  end

  test "call returns :unprocessable_entity when trying to create an invalid shortcode" do
    with_mock Shorty.Repositories.Code, [find_by_shortcode: fn("some-invalid-code") -> nil end] do
      assert {:error, :unprocessable_entity} = CreateShortcode.call(%{shortcode: "some-invalid-code", url: "https://test.pt"})
    end
  end

  test "call returns a new shortcode" do
    params = %{shortcode: "thesis", url: "https://test.pt"}
    changeset = Code.changeset(%Code{}, params)

    with_mock Shorty.Repositories.Code, [
      find_by_shortcode: fn("thesis") -> nil end,
      save!: fn(changeset) -> Map.merge(%Code{}, params) end
    ] do
      assert {:ok, %Code{id: _, shortcode: "thesis"}} = CreateShortcode.call(params)
    end
  end

  test "call returns a new random generated shortcode" do
    changeset = Code.changeset(%Code{}, %{url: "https://test.pt"})

    with_mock Shorty.Repositories.Code, [
      find_by_shortcode: fn(_) -> nil end,
      save!: fn(changeset) -> Map.merge(%Code{}, %{url: "https://test.pt"}) end
    ] do
      assert {:ok, %Code{id: _, shortcode: _}} = CreateShortcode.call(%{shortcode: nil, url: "https://test.pt"})
    end
  end
end
