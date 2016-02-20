defmodule ElixirCoin.DispenserTest do
  use ExUnit.Case

  alias ElixirCoin.Dispenser

  test "custom initial value" do
    Agent.get_and_update(Dispenser, fn x -> {x, 42} end)
    assert 42 == Dispenser.take(1)
  end

  test "take 1" do
    Dispenser.reset
    assert 0 == Dispenser.take(1)
    assert 1 == Dispenser.take(1)
    assert 2 == Dispenser.take(1)
  end

  test "take many" do
    Dispenser.reset
    assert {0, 9} == Dispenser.take(10)
    assert {10, 14} == Dispenser.take(5)
  end

end
