defmodule Shorty.CodeTest do
  use Shorty.ModelCase

  alias Shorty.Code

  @valid_attributes %{
    url: "https://google.pt",
    shortcode: "123456",
    hits: 0
  }
  @invalid_attributes %{}

  test "changeset with valid attributes" do
    changeset = Code.changeset(%Code{}, @valid_attributes)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Code.changeset(%Code{}, @invalid_attributes)

    refute changeset.valid?
  end

  test "changeset with invalid shortcode" do
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "123"}).valid?
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "123456789"}).valid?
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "abc"}).valid?
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "abcdefghi"}).valid?
  end
end
