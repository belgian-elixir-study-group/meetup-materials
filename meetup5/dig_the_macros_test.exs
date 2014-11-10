Code.load_file("dig_the_macros.exs")

ExUnit.start

defmodule DigTheMacrosTest do
  use ExUnit.Case, async: true

  require DigTheMacros

  test "print_AST_and_execute" do

    DigTheMacros.print_AST_and_execute do
      a = 21 + 89
    end

    assert a == 110
  end


  test "print_timestamps_before_and_after_execution" do

    DigTheMacros.print_timestamps_before_and_after_execution do
      a = 21 + 89
    end

    assert a == 110
  end


  test "simple_benchmark" do

    {milliseconds, result} = DigTheMacros.simple_benchmark do
      1..3000 |> Enum.map( &( &1 * 2)) |> Enum.shuffle |> Enum.max
    end

    assert result == 6000
    assert milliseconds > 0
  end

  test "reverse_arguments" do

    res = DigTheMacros.reverse_arguments do
      10 / 5
    end

    assert res == 0.5
  end



end
