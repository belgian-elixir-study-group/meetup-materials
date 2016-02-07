defmodule ElixirCoin.EventManager do
  def start_link() do
    GenEvent.start_link(name: __MODULE__)
  end
end
