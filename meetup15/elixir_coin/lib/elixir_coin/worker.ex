defmodule ElixirCoin.Worker do

  alias ElixirCoin.Server

  def start_link(name, server_pid) do
    Task.start_link(fn -> work(name, server_pid) end)
  end

  def work(name, pid) do
    {:ok, secret, work} = Server.register(pid, name)
    do_work(name, pid, secret, work)
  end

  defp do_work(name, pid, secret, {i, j}) do
    Enum.each(i..j, fn (x) ->
      if ElixirCoin.valid?(secret, x) do
        Server.coin(pid, name, x)
      end
    end)
    {:ok, work} = Server.done(pid, name)
    do_work(name, pid, secret, work)
  end
  defp do_work(name, pid, secret, x) do
    do_work(name, pid, secret, {x, x})
  end

end
