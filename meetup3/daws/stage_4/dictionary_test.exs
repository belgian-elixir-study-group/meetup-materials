defmodule Daws.DictionaryTest do

  use ExUnit.Case

  @tag timeout: 60000

  # use Enum.reduce/3 and Map.update/4 (read the docs for Dict.update/4 )
  test "the table of word signatures return correct word lists for signatures" do

    signature_table = Daws.Dictionary.load_signature_table("american-english-small")

    assert signature_table["aaacceghilloor"] == ["archaeological"]

    assert Enum.sort(signature_table["abest"]) == ["abets", "baste", "beast", "beats"]

    assert Enum.sort(signature_table["aeprs"]) ==
      ["pares", "parse", "pears", "rapes", "reaps", "spare", "spear"]
  end



end
