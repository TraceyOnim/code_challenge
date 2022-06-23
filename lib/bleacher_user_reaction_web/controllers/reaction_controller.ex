defmodule BURWeb.ReactionController do
  use BURWeb, :controller
  alias BUR.Response

  @table :response

  def create(conn, params) do
    case Response.create_response(@table, params) do
      true ->
        conn
        |> put_status(:created)
        |> render("show.json", result: :created)

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("show.json", result: :unprocessable_entity)
    end
  end

  def show(conn, %{"id" => content_id}) do
    result =
      case Response.content_reaction_count(@table, content_id) do
        {:ok, result} -> result
        {:error, result} -> result
      end

    render(conn, "show.json", result: result)
  end
end
