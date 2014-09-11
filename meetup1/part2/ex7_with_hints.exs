# Write a function gcd(x,y) that finds the greatest common divisor
# between two nonnegative integers.
# Algebraically, gcd(x,y) is x if y is zero,
# gcd(y, rem(x,y)) otherwise.

defmodule Find do

  def gcd(x, 0) when x > 0, do: x

  def gcd(x, y) do
  end

end


ExUnit.start

defmodule GcdTest do
  use ExUnit.Case

  test "gcd(32, 10)" do
    assert  Find.gcd(32, 10) == 2
  end

  test "gcd(3808, 238)" do
    assert  Find.gcd(3808, 238) == 238
  end

end
