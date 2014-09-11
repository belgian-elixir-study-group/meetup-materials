# Re-write the same function in a tail-recursive manner. If you don't know what this is,
# go ahead and ask Xavier or Yuri

defmodule Parentheses do

  def balanced? (string) do
    characters = String.codepoints(string)

    count(characters, 0) == 0
  end

end

ExUnit.start

defmodule ParenthesesTest do
  use ExUnit.Case

  test "opening parentheses and closing parentheses are calculated correctly" do

    assert  Parentheses.balanced?("weih((rwkdfn)sle)rh")

    assert  ! Parentheses.balanced?("weih((rwkdfn)sle)r)h")

    assert  ! Parentheses.balanced?("w((eih((rwkdfn)sle)r)h")

  end

end
