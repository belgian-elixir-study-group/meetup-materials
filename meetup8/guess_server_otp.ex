defmodule GuessServer do

  use GenServer

  ### Client API ###

  def start_link(number) do
    GenServer.start_link(__MODULE__, number)
  end

  def guess(pid, sender_name, number) do
    GenServer.call(pid, {:guess, sender_name, number} )
  end

  def nsa_prism(pid, sender_name) do
    GenServer.call(pid, {:i_am_nsa, sender_name} )
  end


  ### Server ###

  def init(number) do
    state = %{
      number:        number,
      call_counter:  0,
      requests_log:  [],
      winner:        nil
    }
    log "server started"

    {:ok, state}
  end

  def handle_call({:guess, sender_name, number}, from, state) when is_number(number) do

    if state.winner do
      log "An attempt to guess the number, but there already a winner: #{state.winner} !"
      response = {:too_late, "Too late, the winner is #{state.winner}"}
      { :reply, response, state }
    else
      {response, state} = process_guess(from, sender_name, number, state)
      { :reply, response, state }
    end

  end

  def handle_call({:i_am_nsa, sender_name}, _from, state) do
    log "#{sender_name} is NSA..."

    { :reply, state.requests_log, state }
  end


  defp process_guess(sender_pid, sender_name, guess, state) do
    # IO.puts "#{guess}  #{state.number}"
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
    {:ok, pid} = GuessServer.start_link 42

    IO.inspect GuessServer.guess(pid, "Mary", 23)
    IO.inspect GuessServer.guess(pid, "Mary", 34)
    IO.inspect GuessServer.guess(pid, "Mary", 100)

    IO.inspect GuessServer.guess(pid, "Mary", 42)

    IO.inspect GuessServer.guess(pid, "John", 42)

    IO.inspect GuessServer.nsa_prism(pid, "Man in Black")

  end

end


GuessServerTest.run
