defmodule BURWeb.ReactionController do
  use BURWeb, :controller
  alias BUR.ResponseServer

  def create(conn, params) do
    case ResponseServer.create_response(params) do
      {:ok, msg} ->
        conn
        |> put_status(:created)
        |> render("show.json", result: msg)

      {:error, msg} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("show.json", result: msg)
    end
  end

  def show(conn, %{"id" => content_id}) do
    result = ResponseServer.content_reaction_count(content_id)
    render(conn, "show.json", result: result)
  end
end
