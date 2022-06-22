defmodule BURWeb.Router do
  use BURWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BURWeb do
    pipe_through :api
    resources "/reaction", ReactionController, only: [:create]
  end
end
