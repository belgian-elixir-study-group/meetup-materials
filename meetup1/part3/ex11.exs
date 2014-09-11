# Improve the previous exercise. Make sure that string " )  (" is invalid.
# Start by copy-pasting your tail-recursive version.
# Just one function clause will do the trick.

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

  test "a closing bracket before an opening bracket is caught" do

    assert  ! Parentheses.balanced?(" )  (")

  end
end
