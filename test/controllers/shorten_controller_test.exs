defmodule Shorty.ShortenControllerTest do
  use Shorty.ConnCase

  @path "/shorten"
  @params %{"shortcode" => "123456", "url" => "https://google.com"}

  @code %Shorty.Code{
    id: "507f1f77bcf86cd799439011",
    url: "https://google.com",
    shortcode: "123456",
    hits: 0,
  }

  test "returns 201 Created when creating a new shortcode" do
    response = build_conn() |> post(@path, @params)

    assert response.status == 201
  end

  test "returns 400 Bad Request when no URL is sent" do
    params = %{@params | "url" => nil}
    response = build_conn() |> post(@path, params)

    assert response.status == 400
  end

  test "returns 409 Conflict when shortcode already exists" do
    Shorty.Repo.insert! @code

    params = %{@params | "shortcode" => @code.shortcode}
    response = build_conn() |> post(@path, params)

    assert response.status == 409
  end

  test "returns 422 Unprocessable Entity when shortcode is not a 6-char alphanumeric string" do
    params = %{@params | "shortcode" => "123"}
    response = build_conn() |> post(@path, params)

    assert response.status == 422
  end
end
