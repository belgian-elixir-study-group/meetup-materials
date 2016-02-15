defmodule ElixirCoin do

  use Application

  def start(_type, _args) do
    IO.puts "Started node #{inspect Node.self()} with cookie #{inspect Node.get_cookie()}"

    ElixirCoin.Supervisor.start_link(secret: "lol", initial_load: 100)
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
