defmodule Daws.AnagramSolver do

  def word_signature(word) when is_binary(word) do
    word
    |>  String.strip
    |>  String.downcase
    |>  String.codepoints
    |>  Enum.sort
    |>  Enum.join
  end


  def anagrams_for(word, signature_table) do
    word_downcased = String.downcase(word)

    Dict.get(signature_table, word_signature(word), [])
    |>  Enum.reject &( &1 == word_downcased )
  end

  def anagrams_for(word) do
    anagrams_for word, Daws.Dictionary.load_signature_table
  end

end
