defmodule Daws.DictionaryTest do

  use ExUnit.Case

  setup_all do # executed once
    {:ok,
      %{
        loaded_words:    Daws.Dictionary.load_words
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


end
