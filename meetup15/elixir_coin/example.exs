ElixirCoin.Supervisor.start_link(secret: "lol")

ElixirCoin.Console.start

ElixirCoin.Server.workload(ElixirCoin.Server, 100)

ElixirCoin.Worker.start_link("Alice", ElixirCoin.Server)
ElixirCoin.Worker.start_link("Bob", ElixirCoin.Server)
ElixirCoin.Worker.start_link("Charles", ElixirCoin.Server)

receive do
end
