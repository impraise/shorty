defmodule Shorty.Repositories.CodeTest do
  use Shorty.ModelCase

  alias Shorty.Code
  alias Shorty.Repositories.Code, as: CodeRepo

  @code %Code{
    url: "https://google.com",
    shortcode: "123456",
    hits: 0,
  }

  test "find_by_shortcode returns a code if it exists" do
    Shorty.Repo.insert! @code

    assert %Code{id: _, shortcode: "123456"} = CodeRepo.find_by_shortcode("123456")
  end

  test "find_by_shortcode returns nothing if it does not exist" do
    refute CodeRepo.find_by_shortcode("unknown")
  end

  test "update! returns an updated code" do
    code = Shorty.Repo.insert! @code

    assert %Code{url: "https://test.pt"} = CodeRepo.update! code, %{url: "https://test.pt"}
  end

  test "update_hit! increments the hit field" do
    code = Shorty.Repo.insert! @code

    assert %Code{hits: 1} = CodeRepo.update_hit! code
  end

  test "save! returns a saved code" do
    assert %Code{} = CodeRepo.save! @code
  end
end
