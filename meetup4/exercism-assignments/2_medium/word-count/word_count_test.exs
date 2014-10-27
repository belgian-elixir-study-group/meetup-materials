if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("word_count.exs")
end

ExUnit.start

defmodule WordsTest do
  use ExUnit.Case

  test "count one word" do
    assert Words.count("word") == Enum.into [{ "word", 1 }], HashDict.new
  end

  test "count one of each" do
    expected = Enum.into [{ "one", 1 }, { "of", 1 }, { "each", 1 }], HashDict.new
    assert Words.count("one of each") == expected
  end

  test "count multiple occurrences" do
    expected = Enum.into [{ "one", 1 }, { "fish", 4 }, { "two", 1 }, { "red", 1 }, { "blue", 1 }], HashDict.new
    assert Words.count("one fish two fish red fish blue fish") == expected
  end

  test "ignore punctuation" do
    expected = Enum.into [{"car", 1}, {"carpet", 1}, {"as", 1}, {"java", 1}, {"javascript", 1}], HashDict.new
    assert Words.count("car : carpet as java : javascript!!&@$%^&") == expected
  end

  test "include numbers" do
    expected = Enum.into [{"testing", 2}, {"1", 1}, {"2", 1}], HashDict.new
    assert Words.count("testing, 1, 2 testing") == expected
  end

  test "hyphens" do
    expected = Enum.into [{"co-operative", 1}], HashDict.new
    assert Words.count("co-operative") == expected
  end

  test "ignore underscores" do
    expected = Enum.into [{"two", 1}, {"words", 1}], HashDict.new
    assert Words.count("two_words") == expected
  end

  test "German" do
    expected = Enum.into [{"götterfunken", 1}, {"schöner", 1}, {"freude", 1}], HashDict.new
    assert Words.count("Freude schöner Götterfunken") == expected
  end

  test "normalize case" do
    expected = Enum.into [{"go", 3}], HashDict.new
    assert Words.count("go Go GO") == expected
  end
end
