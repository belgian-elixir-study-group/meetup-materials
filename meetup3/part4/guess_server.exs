defmodule GuessServer do

  @name  :guess_number_server

  def start_link(number) do
    pid = spawn_link(fn -> init(number) end)

    Process.register(pid, @name)
  end

  defp init(number) do
    state = %{
      number:        number,
      call_counter:  0,
      requests_log:  [],
      winner:        nil
    }

    log "server started"

    loop(state)
  end

  defp loop(state) do
    receive do

      {sender_pid, sender_name, :i_am_nsa} ->
        log "#{sender_name} is NSA..."
        send(sender_pid, state.requests_log)

      {sender_pid, sender_name, guess} when is_number(guess) ->

        if state.winner do
          log "An attempt to guess the number, but there already a winner: #{state.winner} !"
          send(sender_pid, {:too_late, "Too late, the winner is #{state.winner}"})
        else
          state = process_guess(sender_pid, sender_name, guess, state)
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

    send(sender_pid, result)

    request = {sender_pid, sender_name, state.number, result}

    log(request, state.call_counter)

    %{state | call_counter: state.call_counter + 1,  requests_log: [ request | state.requests_log] }
  end

  defp log {_, sender_name, _, result}, call_counter do
    if result == :correct do
      log "#{call_counter}) We have the winner: #{sender_name}!"
    else
      log "#{call_counter}) #{sender_name} tried to guess and the result was: #{result}"
    end
  end

  defp log(message) do
    IO.puts message
  end

end
