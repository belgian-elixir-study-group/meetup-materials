
defmodule GuessServer do

  ### Client API ###

  def start_link(number) do
    spawn_link(fn -> init(number) end)
  end

  def guess(pid, sender_name, number) do
    send(pid, {:guess, self, sender_name, number})

    receive do
      response ->  response
    after 5000 ->
      :erlang.error :timeout
    end
  end

  def nsa_prism(pid, sender_name) do
    send(pid, {:i_am_nsa, self, sender_name})

    receive do
      response ->  response
    after 5000 ->
      :erlang.error :timeout
    end
  end

  ### Server ###

  defp init(number) do
    state = %{
      number:        number,
      call_counter:  0,
      requests_log:  [],
      winner:        nil
    }

    log "server started"

    loop state
  end

  defp loop(state) do
    receive do

      {:i_am_nsa, sender_pid, sender_name} ->
        log "#{sender_name} is NSA..."
        send(sender_pid, state.requests_log)

      {:guess, sender_pid, sender_name, guess} when is_number(guess) ->

        if state.winner do
          log "An attempt to guess the number, but there already a winner: #{state.winner} !"
          send(sender_pid, {:too_late, "Too late, the winner is #{state.winner}"})
        else
          {result, state} = process_guess(sender_pid, sender_name, guess, state)
          send(sender_pid, result)
        end

      _ ->  log "Someone sent garbage. Shame on you."
    end

    loop(state)
  end

  defp process_guess(sender_pid, sender_name, guess, state) do
    result = cond do
      guess == state.number ->

        state = %{state | winner: sender_name }
        :correct

      guess < state.number  -> :your_guess_is_less_than_the_number
      true                  -> :your_guess_is_more_than_the_number
    end

    request = {sender_pid, sender_name, state.number, result}

    log(request, state.call_counter)

    new_state = %{state | call_counter: state.call_counter + 1,  requests_log: [ request | state.requests_log] }

    {result, new_state}
  end

  defp log {_, sender_name, _, result}, call_counter do
    if result == :correct do
      log "#{call_counter}) We have the winner: #{sender_name}!"
    else
      log "#{call_counter}) #{sender_name} tried to guess and the result was: #{result}"
    end
  end

  defp log(message) do
    IO.puts "SERVER: #{message}"
  end

end


defmodule GuessServerTest do

  def run do
    pid = GuessServer.start_link 42

    IO.inspect GuessServer.guess(pid, "Mary", 23)
    IO.inspect GuessServer.guess(pid, "Mary", 34)
    IO.inspect GuessServer.guess(pid, "Mary", 100)

    IO.inspect GuessServer.guess(pid, "Mary", 42)

    IO.inspect GuessServer.guess(pid, "John", 42)

    IO.inspect GuessServer.nsa_prism(pid, "Man in Black")

  end

end


GuessServerTest.run
