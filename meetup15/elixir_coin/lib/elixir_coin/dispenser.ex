defmodule ElixirCoin.Dispenser do

  def start_link(initial_value \\ 0) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def take(1) do
    Agent.get_and_update(__MODULE__, fn x -> {x, x + 1} end)
  end
  def take(n) when n > 1 do
    Agent.get_and_update(__MODULE__, fn x -> {{x, x + n - 1}, x + n} end)
  end

  def reset(initial_value \\ 0) do
    Agent.get_and_update(__MODULE__, fn x -> {x, initial_value} end)
  end

end
