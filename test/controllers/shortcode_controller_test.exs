defmodule Shorty.ShortcodeControllerTest do
  use Shorty.ConnCase

  alias Poison.Parser

  @code %Shorty.Code{
    url: "https://google.com",
    shortcode: "123456",
    hits: 666,
  }

  test "/:shortcode returns 302 Redirect with location header when shortcode exists" do
    Shorty.Repo.insert! @code

    response = build_conn() |> get("/#{@code.shortcode}")
    headers = Enum.into(response.resp_headers, %{})

    assert response.status == 302
    assert headers["location"] == "https://google.com"
  end

  test "/:shortcode/stats returns json with information about shortcode" do
    code = Shorty.Repo.insert! @code

    response = build_conn() |> get("/#{@code.shortcode}/stats")
    json_body = Parser.parse!(response.resp_body)

    assert response.status == 200
    assert json_body == %{
      "lastSeenDate" => code.updated_at |> Ecto.DateTime.to_iso8601,
      "startDate" => code.inserted_at |> Ecto.DateTime.to_iso8601,
      "redirectCount" => code.hits
    }
  end

  test "/:shortcode returns 404 when shortcode does not exist" do
    response = build_conn() |> get("/somerandomstuff")

    assert response.status == 404
  end

  test "/:shortcode/stats returns 404 when shortcode does not exist" do
    response = build_conn() |> get("/somerandomstuff/stats")

    assert response.status == 404
  end
end
