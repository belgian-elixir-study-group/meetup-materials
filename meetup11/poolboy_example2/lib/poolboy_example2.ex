defmodule PoolboyExample2 do
  use Application

  def start(_type, _args) do
    PoolboyExample2.Supervisor.start_link _args
  end
end
