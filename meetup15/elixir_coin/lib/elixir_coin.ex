defmodule ElixirCoin do

  use Application

  def start(_type, args) do
    IO.puts "Started node #{inspect Node.self()} with cookie #{inspect Node.get_cookie()}"

    {:ok, secret} = Dict.fetch(args, :secret)
    initial_load  = Dict.get(args, :initial_load, 1)

    ElixirCoin.Supervisor.start_link(secret: secret, initial_load: initial_load)
  end


  def valid?(secret, x) do
    "#{secret}#{x}"
    |> hash
    |> String.starts_with?("00000")
  end

  defp hash(data) do
    :erlang.md5(data) |> Base.encode16(case: :lower)
  end

end
