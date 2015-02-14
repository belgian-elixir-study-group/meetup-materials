defmodule BSONCodecTest do
  use ExUnit.Case

  import BSONCodecTestHelpers

  test "it supports floats" do
    assert_bson_codec %{"pi" => 3.14159}
  end

  # test "it supports integers" do
  #   assert_bson_codec %{"pos" => 1337, "neg" => -42}
  # end

  # test "it supports strings" do
  #   assert_bson_codec %{"hello" => "World"}
  # end

  # test "it supports booleans" do
  #   assert_bson_codec %{"yes" => true, "no" => false}
  # end

  # test "it supports nil" do
  #   assert_bson_codec %{"void" => nil}
  # end

  # test "it supports nested documents" do
  #   assert_bson_codec %{"nested1" => %{"nested2" => %{"key" => "value"}}}
  # end

  # test "it supports arrays" do
  #   assert_bson_codec %{"array" => ["one", 2, 3.0]}
  # end

  # test "it supports regular expressions" do
  #   assert_bson_codec %{"regex" => ~r/foo+bar?/i}
  # end

  # test "it supports empty documents" do
  #   assert_bson_codec %{}
  # end

  # test "it works with complex documents" do
  #   doc = %{
  #     "string" => "foobar",
  #     "int" => 1234567890,
  #     "float" => 3.14159,
  #     "yes" => true,
  #     "no" => false,
  #     "void" => nil,
  #     "regex" => ~r/foo/i,
  #     "nested" => %{
  #       "nested_key" => "value",
  #       "nested_other" => "property",
  #       "nested_array" => ["one", "two", "three"],
  #     }
  #   }
  #   assert_bson_codec doc
  # end

end
