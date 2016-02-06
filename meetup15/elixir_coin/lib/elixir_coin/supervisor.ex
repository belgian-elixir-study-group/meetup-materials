defmodule ElixirCoin.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    children = [
      worker(ElixirCoin.Dispenser, []),
      worker(ElixirCoin.Server, [[secret: Keyword.fetch!(args, :secret)]])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
