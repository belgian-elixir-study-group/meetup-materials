defmodule PoolboyExample2Test do

  use ExUnit.Case, async: false


  test "getting lots or worker via transaction" do
    parent = self
    tasks = 20
    for i <- 1..tasks do
      spawn fn() ->
        :poolboy.transaction(:my_pool, fn(worker_pid) ->
          IO.inspect PoolboyExample2.Worker.hello(worker_pid, "Yuri #{i}")

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
