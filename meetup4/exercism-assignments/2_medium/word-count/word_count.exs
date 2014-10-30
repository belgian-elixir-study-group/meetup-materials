defmodule Words do
  def count phrase do

    phrase |> cleanup |> to_list |> build_dictionary

  end

  defp to_list phrase do
    Regex.split ~r/\s+/, phrase
  end

  defp cleanup phrase do
    Regex.replace(~r/[^\w]|_/, phrase, " ") |>
      String.strip                        |>
      String.downcase
  end

  defp build_dictionary words do
    List.foldl(
      words,
      HashDict.new,
      fn(word, accumulator) ->
        HashDict.update(accumulator, word, 1, &(&1 + 1))
      end
    )
  end

end