defmodule Daws.DictionaryTest do

  use ExUnit.Case

  setup_all do # executed once
    {:ok,
      %{
        loaded_words:    Daws.Dictionary.load_words,
        signature_table: Daws.Dictionary.load_signature_table
      }
    }
  end

  test "words are a list", %{loaded_words: loaded_words} do
    assert is_list(loaded_words)
  end

  test "at least 50K words", %{loaded_words: loaded_words}  do
    assert length(loaded_words) > 50_000
  end


  test "the dictionary is valid", %{loaded_words: loaded_words} do
    assert "dynamically" in loaded_words
    assert "abdicating"  in loaded_words
  end

  test "the table of word signatures is a big dict", %{signature_table: signature_table}  do
    assert Dict.size(signature_table) > 10_000
  end

  test "the table of word signatures return correct word lists for signatures", %{signature_table: signature_table}  do
    assert signature_table["aaacceghilloor"] == ["archaeological"]

    assert Enum.sort(signature_table["abest"]) == ["Bates", "abets", "baste", "bates", "beast", "beats", "betas", "tabes"]


    assert Enum.sort(signature_table["aeprs"]) ==
      ["Pears", "Spear", "asper", "pares", "parse", "pears", "prase", "presa", "rapes", "reaps", "spare", "spear"]

  end

  test "richest_word_signature", %{signature_table: signature_table}  do

    {"aeprs", words} = Daws.Dictionary.richest_word_signature(signature_table)

    assert Enum.sort(words) ==  ["Pears", "Spear", "asper", "pares", "parse", "pears", "prase", "presa", "rapes", "reaps", "spare", "spear"]

  end

end
