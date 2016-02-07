defmodule ElixirCoin.Console do
  use GenEvent

  def start() do
    GenEvent.add_handler(ElixirCoin.EventManager, __MODULE__, [])
  end

  def init(_args) do
    {:ok, 1}
  end

  def handle_event({:miner_registered, name}, msg_count) do
    msg_count
    |> log("Miner '#{name}' has succesfully registered")
    |> ok
  end

  def handle_event({:coin_mined, name, x}, msg_count) do
    msg_count
    |> log("Miner '#{name}' has succesfully mined 1 coin: #{x}")
    |> ok
  end

  def handle_event({:workload_changed, old, new}, msg_count) do
    msg_count
    |> log("Workload has been changed from #{old} to #{new}")
    |> ok
  end

  def handle_event(_, msg_count) do
    {:ok, msg_count}
  end

  #
  #
  #

  defp log(msg_count, message) do
    IO.puts("#{prefix(msg_count)} #{message}")
    msg_count
  end

  defp prefix(msg_count, digits \\ 6) do
    msg_count
    |> to_string
    |> String.rjust(digits, ?0)
  end

  defp ok(msg_count) do
    {:ok, msg_count + 1}
  end
end
