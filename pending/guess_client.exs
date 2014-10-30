# start a script like this:
# elixir --cookie devspace --name ANY_NAME_FOR_YOUR_NODE  guess_clent_example.exs

# start iex like this:
# iex --cookie devspace --name ANY_NAME_FOR_YOUR_NODE

# To connect to another node for debugging purposes:
# Node.connect(:'guess@192.168.1.37')

# To see a list of connected nodes
# Node.list

defmodule GuessClient do

  @remote_node      :'guess@192.168.1.37' # perhaps
  @remote_pid_name  :guess_number_server


  defp foo do
    # sending a message to a remote node
    send {@remote_pid_name, @remote_node}, MESSAGE_YOU_SEND
  end

end


