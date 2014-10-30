defmodule Daws.Dictionary do

  @dictionary "american-english-large"

  # you'll need a function from Enum
  def richest_word_signature(sig_table) do

  end


  def load_signature_table(dictionary_filename \\ @dictionary) do
  end

  # also: remove end-of-line characters
  def load_words(dictionary_filename \\ @dictionary) do
    stream = File.stream!(dictionary_path(dictionary_filename) )

    Enum.reduce stream, [], fn(line, lines) ->

    end
  end

  # You will need 1 function from File to get the current directory
   # and 1 function from Path to join path fragments into one path
  defp dictionary_path(dictionary_filename \\ @dictionary) do
  end

end
