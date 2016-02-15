defmodule ElixirCoin.MinersTest do
  use ExUnit.Case

  alias ElixirCoin.Miners

  setup do
    {:ok, %{miners: %{}, name: "test"}}
  end

  test "registration", %{miners: miners, name: name} do
    refute Miners.registered?(miners, name)

    assert {:ok, miners} = Miners.register(miners, name)

    assert Miners.registered?(miners, name)

    assert {:error, _} = Miners.register(miners, name)
  end

  test "coin tracking", %{miners: miners, name: name} do
    {:ok, miners} = Miners.register(miners, "test")

    assert {:ok, 0} == Miners.coins_mined(miners, name)

    {:ok, miners} = Miners.new_coin(miners, name)
    assert {:ok, 1} == Miners.coins_mined(miners, name)

    {:ok, miners} = Miners.new_coin(miners, name)
    assert {:ok, 2} == Miners.coins_mined(miners, name)
  end

  test "leaderboard", %{miners: miners} do
    {:ok, miners} = Miners.register(miners, "champ")
    {:ok, miners} = Miners.register(miners, "runnerup")
    {:ok, miners} = Miners.register(miners, "loser")

    {:ok, miners} = Miners.new_coin(miners, "champ")
    {:ok, miners} = Miners.new_coin(miners, "runnerup")
    {:ok, miners} = Miners.new_coin(miners, "champ")
    {:ok, miners} = Miners.new_coin(miners, "loser")
    {:ok, miners} = Miners.new_coin(miners, "champ")
    {:ok, miners} = Miners.new_coin(miners, "runnerup")

    expected = [
      {"champ", 3},
      {"runnerup", 2},
      {"loser", 1},
    ]

    assert expected == Miners.leaderboard(miners)
  end

end
