#
# Write a function which flushes the mailbox of the current process and returns
# a list with the pending messages
#

defmodule Mailbox do

  def flush() do
    _flush([])
  end

  defp _flush(acc) do
    receive do
      m -> _flush([ m | acc])
    after
      0 -> Enum.reverse acc
    end
  end

end


ExUnit.start

defmodule MailboxTest do
   use ExUnit.Case

  test "flush returns the messages in order" do
    send self, :a
    send self, {:b, :c}
    send self, [:d]
    assert [:a, {:b, :c}, [:d]] == Mailbox.flush()
  end

  # Uncomment this test case when the first test passes
  test "flush returns an empty list when the mailbox is empty" do
    assert [] == Mailbox.flush()
  end

end
