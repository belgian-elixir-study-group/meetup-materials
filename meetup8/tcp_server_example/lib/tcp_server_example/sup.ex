defmodule TcpServerExample.Sup do
  use Supervisor

  def start_link(sock) do
    Supervisor.start_link(__MODULE__, [sock], name: :tcp_server_supervisor)
  end

  def start_child() do

    # start_child(supervisor, child_spec)
    # BUT:
    # child_spec should be a valid child specification
    # (unless the supervisor is a :simple_one_for_one supervisor).
    # The child process will be started as
    # defined in the child specification.

    # In the case of :simple_one_for_one, the child specification
    # defined in the supervisor will be used and instead of a child_spec,
    # an arbitrary list of terms is expected. The child process will
    # then be started by appending the given list to the existing
    # function arguments in the child specification.

    IO.puts "supervisor spawning a handler..."
    Supervisor.start_child(:tcp_server_supervisor, [])
  end


  def init([sock]) do

    worker_specification =  worker(
      TcpServerExample.Handler,
      [sock],
      restart:  :temporary,   # How to restart:  temporary means processes that should never be restarted
      shutdown: :brutal_kill  # How to shutdown: brutal_kill means the child process is unconditionally terminated using exit
    )

    children = [worker_specification]

    supervise(children, strategy: :simple_one_for_one)
  end
end
