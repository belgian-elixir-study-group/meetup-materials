defmodule Daws.Supervisor do
  use Supervisor

  def start_link(dictionary_filename) do
    Supervisor.start_link(__MODULE__, [dictionary_filename])
  end

  def init(dictionary_filename) do
    children = [
      worker(Daws.DictionaryWorker, [dictionary_filename])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
