defmodule BURWeb.ReactionController do
  use BURWeb, :controller
  alias BUR.Reaction

  def create(conn, params) do
    {:ok, params} = Reaction.create_reaction(params)
    render(conn, "show.json", params: params)
  end
end
