defmodule ElixirCoin.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    children = [
      worker(ElixirCoin.EventManager, []),
      worker(ElixirCoin.Dispenser, []),
      worker(ElixirCoin.Server, [
        [
          secret: Keyword.fetch!(args, :secret),
          initial_load: Keyword.fetch!(args, :initial_load)
        ]
      ])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
