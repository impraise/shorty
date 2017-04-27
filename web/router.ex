defmodule Shorty.Router do
  use Shorty.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Shorty do
    pipe_through :api

    get  "/:shortcode",       ShortcodeController, :index
    get  "/:shortcode/stats", ShortcodeController, :stats
    post "/shorten",          ShortenController,   :create
  end
end
