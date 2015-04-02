defmodule Worker do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def hello(worker_pid, name) do
    GenServer.call(worker_pid, {:hello, name})
  end

  def init(_opts) do
    { :ok, [] }
  end


  def handle_call({:hello, name}, _from, state) do
    :timer.sleep(1000)
    { :reply, "hello, #{name}", state }
  end

end


defmodule Test do
  def run do
    {:ok, pid1} = Worker.start_link()
    {:ok, pid2} = Worker.start_link()
    # IO.inspect pid
    IO.inspect Worker.hello(pid1, "Yuri")
    IO.inspect Worker.hello(pid2, "Yuri")
  end


end

Test.run

