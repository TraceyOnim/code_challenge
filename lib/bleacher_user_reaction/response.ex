defmodule BUR.Response do
  alias BUR.Response

  @moduledoc """
  This module is responsible for manipulating data relating to reaction made to a content by users
  """
  defstruct [:type, :user_id, :reaction_type, :action]

  @type t :: %__MODULE__{
          type: String.t(),
          user_id: String.t(),
          reaction_type: String.t(),
          action: String.t()
        }

  @doc """
  inserts users reactions of the content
  """
  @spec create_response(atom(), map(), Response.t()) :: boolean()
  def create_response(table, %{"content_id" => content_id} = params, response \\ %Response{}) do
    params = Map.new(params, fn {k, v} -> {String.to_atom(k), v} end)
    :ets.insert(table, {content_id, struct(response, params)})
  end

  @doc """
  fetches the response of the given content
  """
  @spec get_response(atom(), String.t()) :: [tuple(), ...]
  def get_response(table, content_id) do
    :ets.lookup(table, content_id)
  end

  @doc """
  returns the count of reaction of a particular content.The result is the count of unique users who
  added a fire reaction and didn't later remove it
  """
  @spec content_reaction_count(atom(), String.t()) :: map()
  def content_reaction_count(table, content_id) do
    responses = get_response(table, content_id)

    if Enum.empty?(responses) do
      {:error, :not_found}
    else
      reaction_count =
        responses
        |> Enum.map(fn {_content_id, response} -> response end)
        |> Enum.group_by(fn response -> response.user_id end)
        |> Enum.count(fn {_user_id, responses} -> Enum.count(responses) == 1 end)

      {:ok, %{content_id: content_id, reaction_count: %{fire: reaction_count}}}
    end
  end
end
