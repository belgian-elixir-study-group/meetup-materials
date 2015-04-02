defmodule Worker do

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


defmodule PoolboyExample1Test do
  use ExUnit.Case, async: false

  setup_all do # executed once
    {:ok, pool} = :poolboy.start(
      worker_module: Worker,
      size: 3,
      max_overflow: 0
    )
    # IO.inspect pool
    {:ok,  %{ pool: pool } }
  end

  test "genserver is ok and is not a singleton named process" do
    {:ok, pid1} = Worker.start_link()
    {:ok, pid2} = Worker.start_link()
    IO.inspect Worker.hello(pid1, "Yuri")
    IO.inspect Worker.hello(pid2, "Yuri")
  end

  test "getting a worker with checkin/checkout",  %{pool: pool} do

    worker_pid = :poolboy.checkout(pool)
    IO.inspect Worker.hello(worker_pid, "Yuri")
    :poolboy.checkin(pool, worker_pid)

  end

  test "getting a worker via transaction",  %{pool: pool} do
    :poolboy.transaction(pool, fn(worker_pid) ->
      IO.inspect Worker.hello(worker_pid, "Yuri")
    end)
  end


  test "getting lots or worker via transaction",  %{pool: pool} do
    parent = self
    tasks = 20
    for i <- 1..tasks do
      spawn fn() ->
        :poolboy.transaction(pool, fn(worker_pid) ->
          IO.inspect Worker.hello(worker_pid, "Yuri #{i}")

          if i == tasks do
            send(parent, :all_tasks_executed)
          end
        end)
      end
    end

    receive do
      :all_tasks_executed -> :ok
    end


  end
end
