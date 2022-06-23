defmodule BUR.ResponseServer do
  use GenServer
  alias BUR.Response

  @table :response

  # client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def create_response(params) do
    GenServer.call(__MODULE__, {:create, params})
  end

  def content_reaction_count(content_id) do
    GenServer.call(__MODULE__, {:count, content_id})
  end

  # server

  @impl true

  def init(_) do
    Response.response_table()
    {:ok, []}
  end

  @impl true
  def handle_call({:create, params}, _from, state) do
    case Response.create_response(@table, params) do
      true ->
        {:reply, {:ok, :created}, state}

      _ ->
        {:reply, {:error, :unprocessable_entity}, state}
    end
  end

  @impl true
  def handle_call({:count, content_id}, _from, state) do
    case Response.content_reaction_count(@table, content_id) do
      {:ok, count} ->
        {:reply, count, state}

      {:error, msg} ->
        {:reply, msg, state}
    end
  end
end
