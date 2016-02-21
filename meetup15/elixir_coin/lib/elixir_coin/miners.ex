defmodule ElixirCoin.Miners do

  defmodule Miner do
    defstruct name: nil,
              coins_mined: 0
  end

  def registered?(miners, name) do
    Dict.has_key?(miners, name)
  end

  def register(miners, name) do
    if registered?(miners, name) do
      {:error, "'#{name}' is already registered"}
    else
      {:ok, Dict.put_new(miners, name, %Miner{name: name})}
    end
  end

  def new_coin(miners, name) do
    if registered?(miners, name) do
      {:ok, Dict.update!(miners, name, fn (miner) -> %{miner | coins_mined: miner.coins_mined + 1} end)}
    else
      {:error, "unkown miner '#{name}'"}
    end
  end

  def coins_mined(miners, name) do
    case Dict.fetch(miners, name) do
      {:ok, miner} ->
        {:ok, miner.coins_mined}
      :error ->
        {:error, "unkown miner '#{name}'"}
    end
  end

  def leaderboard(miners) do
    miners
    |> Enum.map(fn ({name, miner}) -> {name, miner.coins_mined} end)
    |> Enum.sort_by(fn ({_, coins_mined}) -> -coins_mined end)
  end

end
