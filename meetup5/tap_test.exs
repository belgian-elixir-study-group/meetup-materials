Code.load_file("tap.exs")

ExUnit.start

defmodule TapTest do
  use ExUnit.Case, async: true

  require Tap

  test "simple_tap" do

    result = Tap.simple_tap(2 + 3) do
      send self, "I got executed"
    end

    assert_received "I got executed"

    assert result == 5

  end


  test "tap" do


    result = Tap.tap {:ok, 42} do

      {:ok, _} ->
        send self, "I got executed"

      {:error, _}  ->
        send self, "OOOPS"

    end

    assert_received "I got executed"

    assert result == {:ok, 42}

  end




end
