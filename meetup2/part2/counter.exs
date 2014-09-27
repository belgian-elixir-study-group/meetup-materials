#
# Let's extend our little counter process example!
#
# Your tasks:
#  1) Implement an incrementable counter based on public API described below
#  2) Add a new Counter.dec/1 public function which decrements the counter
#  3) A counter must always remain >= 0, make sure an exception is raised otherwise.
#
#     You can raise an exception with:
#
#       raise ArgumentError, "error message"
#
#  Make baby steps and uncomment the test cases as you make progress

defmodule Counter do

  @doc "A simple counter showing how to manage state using processes"

  @doc "Creates a new counter, initialized to 0"
  def start do
    spawn_link(Counter, :loop, [0] )
  end

  @doc "Increments the given counter by 1"
  def inc(counter) do
    send(counter,  :inc )
  end

  def dec(counter) do
    send(counter,  :dec )
  end


  @doc "Returns the current value of the given counter"
  def value(counter) do

    send(counter, {self, :val})

    receive do
      val -> val
    end

  end

  @doc "Destroy the given counter and return its last value"
  def terminate(counter) do
    send(counter, {self, :quit})

    receive do
      val -> val
    end
  end


  def loop(val) do
    receive do
      :inc -> loop(val+1)

      :dec -> loop(val-1)

      {sender, :val} ->
        send(sender, val)
        loop(val)

      {sender, :quit} ->
        send(sender, val)
    end
  end

end

ExUnit.start

defmodule CounterTest do
  use ExUnit.Case

  #
  # Step 1
  #

  test "counter starts at 0" do
    c = Counter.start
    assert 0 == Counter.value(c)
  end

  test "counter incrementation" do
    c = Counter.start
    Counter.inc(c)
    Counter.inc(c)
    Counter.inc(c)
    assert 3 == Counter.value(c)
  end

  test "multiple counters" do
    c1 = Counter.start
    c2 = Counter.start
    c3 = Counter.start
    Counter.inc(c1)
    Counter.inc(c2)
    Counter.inc(c2)
    assert 1 == Counter.value(c1)
    assert 2 == Counter.value(c2)
    assert 0 == Counter.value(c3)
  end

  test "terminate returns final value of counter" do
    c = Counter.start
    Counter.inc(c)
    assert 1 == Counter.terminate(c)
  end

  #
  # Step 2
  #

  test "counter decrementation" do
    c = Counter.start
    Counter.inc(c)
    Counter.dec(c)
    Counter.inc(c)
    assert 1 == Counter.value(c)
  end

  #
  # Step 3
  #

  # The style of this test is highly unorthodox :)
  test "counter decrementation below zero" do
    Process.flag(:trap_exit, true)
    c = Counter.start
    Counter.dec(c)
    assert_receive {:EXIT, ^c, {%ArgumentError{message: _}, _}}, 1_000
  end

end
