defmodule PoolboyExample2.Worker do

  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end


  def hello(worker_pid, name) do
    GenServer.call(worker_pid, {:hello, name})
  end

  def init(state) do
    { :ok, state }
  end


  def handle_call({:hello, name}, _from, state) do
    :timer.sleep(500)
    { :reply, "hello, #{name}", state }
  end

end