defmodule ElixirCoin.EventManager do
  def start_link() do
    res = GenEvent.start_link(name: __MODULE__)
    ElixirCoin.Console.start
    res
  end
end
