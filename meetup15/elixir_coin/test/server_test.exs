defmodule ElixirCoin.ServerTest do
  use ExUnit.Case

  alias ElixirCoin.{Server, EventManager, Dispenser}

  setup do
    server = ElixirCoin.Server
    ElixirCoin.Server.reset(server, 2)
    Agent.get_and_update(ElixirCoin.Dispenser, fn x -> {x, 1} end)
    {:ok, %{server: server}}
  end

  test "registration", %{server: pid} do
    # IO.inspect Server.register(pid, "Alice")
    # assert {:ok, "lol", 0} = Server.register(pid, "Alice")
    # assert {:ok, "lol", 1} = Server.register(pid, "Bob")
    # assert {:error, _} = Server.register(pid, "Bob")
  end

  # test "valid coin found", %{server: pid} do
  #   Server.register(pid, "Alice")
  #   assert {:ok, 1} = Server.coin(pid, "Alice", 1)
  #   assert {:error, _} = Server.coin(pid, "Alice", 123)
  # end

  # test "done", %{server: pid} do
  #   Server.register(pid, "Alice")
  #   assert {:ok, 1} = Server.done(pid, "Alice")
  # end

  # test "leaderboard", %{server: pid}  do
  #   assert {:ok, []} = Server.leaderboard(pid)

  #   Server.register(pid, "Alice")
  #   assert {:ok, [{"Alice", 0}]} = Server.leaderboard(pid)
  # end

  # test "workload", %{server: pid}  do
  #   Server.workload(pid, 10)
  #   assert {:ok, _, {0, 9}} = Server.register(pid, "Alice")

  #   Server.workload(pid, 1)
  #   assert {:ok, _, 10} = Server.register(pid, "Bob")

  #   Server.workload(pid, 100)
  #   assert {:ok, _, {11, 110}} = Server.register(pid, "Charles")
  # end

  # test "worth", %{server: pid} do
  #   assert {:ok, 0} = Server.worth(pid)

  #   Server.register(pid, "Alice")
  #   Server.coin(pid, "Alice", 1)

  #   assert {:ok, 1} = Server.worth(pid)
  # end
end
