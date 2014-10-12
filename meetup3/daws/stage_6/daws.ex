defmodule Daws do
  use Application

  def start(_type, dictionary_filename) do
    IO.puts "Running AnagramWebServer with Cowboy on http://localhost:4000"
    Plug.Adapters.Cowboy.http Daws.Plug, []
    Daws.Supervisor.start_link(dictionary_filename)
  end
end
