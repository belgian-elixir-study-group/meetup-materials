defmodule Tap do


  # Instead of this:

  # def foo(products) do
  #   prices = products |> Enum.map(&(&1.price))
  #   avrg = average(prices)
  #   IO.puts "the average is #{avrg}"
  #   avrg
  # end

  # we want to code it like this:

  # def foo(products) do
  #   prices = products |> Enum.map(&(&1.price))
  #   tap average(prices) do
  #     IO.puts "the average is #{avrg}"
  #   end
  # end



  defmacro simple_tap(expression, do: block) do

  end


  defmacro tap(expression, block) do

  end


end
