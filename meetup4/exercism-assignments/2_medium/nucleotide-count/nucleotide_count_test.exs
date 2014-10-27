if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("dna.exs")
end

ExUnit.start

defmodule DNATest do
  use ExUnit.Case, async: true
  doctest DNA

  test "empty dna string has no adenosine" do
    assert DNA.count('', ?A) == 0
  end

  test "empty dna string has no nucleotides" do
    expected = Enum.into [{?A, 0}, {?T, 0}, {?C, 0}, {?G, 0}], HashDict.new
    assert DNA.nucleotide_counts('') == expected
  end

  test "repetitive cytidine gets counted" do
    assert DNA.count('CCCCC', ?C) == 5
  end

  test "repetitive sequence has only guanosine" do
    expected = Enum.into [{?A, 0}, {?T, 0}, {?C, 0}, {?G, 8}], HashDict.new
    assert DNA.nucleotide_counts('GGGGGGGG') == expected
  end

  test "counts only thymidine" do
    assert DNA.count('GGGGGTAACCCGG', ?T) == 1
  end

  test "dna has no uracil" do
    assert DNA.count('GATTACA', ?U) == 0
  end

  test "counts all nucleotides" do
    s = 'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
    expected = Enum.into [{?A, 20}, {?T, 21}, {?C, 12}, {?G, 17}], HashDict.new
    assert DNA.nucleotide_counts(s) == expected
  end
end
