defmodule ElixirCoinTest do
  use ExUnit.Case

  test "valid?" do
    refute ElixirCoin.valid?("foo", 123)
    assert ElixirCoin.valid?("Serun+u", 1)
  end
end
