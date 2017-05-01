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

  test "changeset with invalid shortcode (less than 4 chars)" do
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "123"}).valid?
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "abc"}).valid?
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "A_c"}).valid?
    refute Code.changeset(%Code{}, %{@valid_attributes | shortcode: "___"}).valid?
  end

  test "changeset with several valid shortcodes (minimum of 4 chars)" do
    assert Code.changeset(%Code{}, %{@valid_attributes | shortcode: "abcdefghi"}).valid?
    assert Code.changeset(%Code{}, %{@valid_attributes | shortcode: "123456789"}).valid?
    assert Code.changeset(%Code{}, %{@valid_attributes | shortcode: "ABCabc___"}).valid?
    assert Code.changeset(%Code{}, %{@valid_attributes | shortcode: "Abc123___"}).valid?
  end

  test "generate_random_shortcode/0 returns a valid random shortcode" do
    assert ~r/^[0-9a-zA-Z_]{4,}$/ |> Regex.match?(Code.generate_random_shortcode())
  end
end
