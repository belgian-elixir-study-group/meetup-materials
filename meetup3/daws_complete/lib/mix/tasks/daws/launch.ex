defmodule Mix.Tasks.Launch do
  use Mix.Task

  @shortdoc "run anagram webserver"

  def run(_) do
    Mix.Task.run "app.start", []

    # IO.puts "Running AnagramWebServer with Cowboy on http://localhost:4000"
    # Plug.Adapters.Cowboy.http Daws.Plug, []

    no_halt

  end


  defp no_halt do
    unless iex_running?, do: :timer.sleep(:infinity)
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) && IEx.started?
  end


end
