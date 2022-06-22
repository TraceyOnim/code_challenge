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
  creates a response table that will contain the records of user reactions to a content
  """
  @spec response_table() :: atom()
  def response_table do
    :ets.new(:response, [:bag, :named_table])
  end

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
    reaction_count =
      table
      |> get_response(content_id)
      |> Enum.map(fn {_content_id, response} -> response end)
      |> Enum.group_by(fn response -> response.user_id end)
      |> Enum.count(fn {_user_id, responses} -> Enum.count(responses) == 1 end)

    %{content_id: content_id, reaction_count: reaction_count}
  end
end
