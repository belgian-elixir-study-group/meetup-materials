# Shamelessly stolen from Dave Thomas
# http://www.confreaks.com/videos/4119-elixirconf2014-opening-keynote-think-different

# Please process a list in such a way that identical consecutive elements
# are replaced by a tuple {a, n} where a is the element and n is the number
# of times the element appears

# [a, a, ...] -> [ {a, 2}, ...]
# [ {a, n}, a, ...] -> [ {a, n + 1}, ...]



defmodule DaveThomas do

  def encode(list), do: _encode(list, [])

  defp _encode([], result), do: Enum.reverse(result)

end

ExUnit.start

defmodule DaveThomasTest do
  use ExUnit.Case

  test "encode" do
    assert DaveThomas.encode([ 1, 4 ,4, 5, 4, :a, :a, :a, :g, 56, 2]) == [ 1, {4, 2}, 5, 4, {:a, 3}, :g, 56, 2]
  end

end
