defmodule TcpServerExample do

  use Application

  def start(_type, port: port) do

    {:ok, sock} = :gen_tcp.listen(port, active: true)

    IO.puts "listening on port #{port}"

    case TcpServerExample.Sup.start_link(sock) do
      {:ok, pid} ->
        TcpServerExample.Sup.start_child
        {:ok, pid}

      other ->
        {:error, other}
    end
  end

end
