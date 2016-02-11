
IO.puts "Started node #{inspect Node.self()} with cookie #{inspect Node.get_cookie()}"

ElixirCoin.Supervisor.start_link(secret: "lol")

ElixirCoin.Console.start

server_name = ElixirCoin.Server

ElixirCoin.Server.workload(server_name, 100)

receive do
end
