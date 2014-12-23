defmodule TcpServerExample.Handler do

  use GenServer

  def start_link(sock) do
    GenServer.start_link(__MODULE__, sock)
  end

  def init(sock) do
    {
      :ok,
      {:state, sock},
      0 # zero timeout!!!
    }
  end

  def handle_info(:timeout, state = {:state, sock}) do
    log "Handler waiting for a connection..."
    {:ok, _sock} = :gen_tcp.accept(sock) # waiting here
    log "Connection established..."
    TcpServerExample.Sup.start_child
    {:noreply, state}
  end


  def handle_info({:tcp, connection_socket, raw_data}, state) do
    log "Incoming data..."

    reversed = raw_data
              |> List.to_string
              |> String.rstrip
              |> String.reverse

    :gen_tcp.send(connection_socket, "#{reversed}\n")

    {:noreply, state}
  end



  def handle_info({:tcp_closed, _socket}, state) do
    log "Connection closed..."
    {:stop, :normal, state}
  end


  defp log(message) do
    this = :erlang.pid_to_list(self)
    IO.puts "#{this}: #{message}"
  end

end
