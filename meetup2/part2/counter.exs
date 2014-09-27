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
