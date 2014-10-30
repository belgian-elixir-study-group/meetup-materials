defmodule Daws.Dictionary do

  # @dictionary "american-english-very-small"
  @dictionary "american-english-large"


  def richest_word_signature(sig_table) do
    # TO DO
  end


  def load_signature_table(dictionary_filename \\ @dictionary) do

    # TO DO

  end

  def load_words(dictionary_filename \\ @dictionary) do
    File.stream!(dictionary_path(dictionary_filename) ) |> Enum.map &( String.rstrip/1 )
  end

  defp dictionary_path(dictionary_filename \\ @dictionary) do

    # TO DO

  end

end
