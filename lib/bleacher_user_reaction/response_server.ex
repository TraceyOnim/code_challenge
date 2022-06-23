defmodule BUR.ResponseServer do
  use GenServer
  alias BUR.Response

  @table :response

  # client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # server

  @impl true

  def init(_) do
    :ets.new(@table, [
      :bag,
      :named_table,
      :public,
      write_concurrency: true,
      read_concurrency: true
    ])

    {:ok, []}
  end
end
