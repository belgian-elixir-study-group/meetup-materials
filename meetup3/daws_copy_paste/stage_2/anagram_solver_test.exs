defmodule Daws.AnagramSolverTest do
  use ExUnit.Case

  # you'll need String and Enum
  test "word signature" do
    assert Daws.AnagramSolver.word_signature("Goodbye")       == "bdegooy"
    assert Daws.AnagramSolver.word_signature("  Hello ")      == "ehllo"
    assert Daws.AnagramSolver.word_signature(" Calligraphic") == "aaccghiillpr"
  end

end
