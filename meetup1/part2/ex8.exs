# Find a function in module List which would help you implement the following:


defmodule ReduceList do

end


ExUnit.start

defmodule ReduceListTest do
  use ExUnit.Case

  test "sum" do
    assert  [1,2,3,4] |> ReduceList.by(:sum) == 10
  end

  test "multiplication" do
    assert  [1,2,3,4] |> ReduceList.by(:multiplication) == 24
  end


  test "concatenation" do
    assert  ["1", "2", "3", "4"] |> ReduceList.by(:concatenation) == "4321"
  end

end
