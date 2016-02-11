
IO.puts "Started node #{inspect Node.self()} with cookie #{inspect Node.get_cookie()}"

Node.connect(:"server@127.0.0.1")

server_name = {ElixirCoin.Server, :"server@127.0.0.1"}

ElixirCoin.Worker.start_link("Alice", server_name)

receive do
end
