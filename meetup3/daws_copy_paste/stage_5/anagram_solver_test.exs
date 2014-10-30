defmodule Daws.AnagramSolverTest do
  use ExUnit.Case

  setup_all do # executed once
    {:ok,  %{ signature_table: Daws.Dictionary.load_signature_table } }
  end

  # you'll need String and Enum
  test "word signature" do
    assert Daws.AnagramSolver.word_signature("Goodbye")       == "bdegooy"
    assert Daws.AnagramSolver.word_signature("  Hello ")      == "ehllo"
    assert Daws.AnagramSolver.word_signature(" Calligraphic") == "aaccghiillpr"
  end

  test "anagrams for", %{signature_table: signature_table}  do
    assert Daws.AnagramSolver.anagrams_for("beast", signature_table) == ["Bates", "abets", "baste", "bates", "beats", "betas", "tabes"]

    assert Daws.AnagramSolver.anagrams_for("sdlfknjsdfknlf") == []
  end

end
