defmodule Daws.Dictionary do

  # @dictionary "american-english-very-small"
  @dictionary "american-english-large"


  def richest_word_signature(sig_table) do
    Enum.max_by sig_table, fn({_, words}) -> length(words) end
  end


  def load_signature_table(dictionary_filename \\ @dictionary) do

    load_words(dictionary_filename)
    |>  Enum.reduce  HashDict.new, fn(word, map) ->
          signature = Daws.AnagramSolver.word_signature(word)

          Dict.update(map, signature, [word],  &( [word | &1 ] )  )
        end
  end

  def load_words(dictionary_filename \\ @dictionary) do
    File.stream!(dictionary_path(dictionary_filename) ) |> Enum.map &( String.rstrip/1 )
  end

  defp dictionary_path(dictionary_filename \\ @dictionary) do
    {:ok, current_dir} = File.cwd
    Path.join [current_dir, "priv", dictionary_filename]
  end

end
