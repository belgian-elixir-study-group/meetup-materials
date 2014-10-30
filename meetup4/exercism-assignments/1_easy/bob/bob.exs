defmodule Teenager do

  @whatever "Whatever."

  # @responses %{
  #   whatever:     "Whatever.",
  #   sure:         "Sure."
  # }



  def hey(input) do



    cond do

      String.replace(input, " ", "") == "" -> "Fine. Be that way!"

      String.upcase(input) == input -> "Woah, chill out!"
      String.last(input)   == "?"   -> "Sure."
      String.last(input)   == "!"   -> @whatever
      true                          -> @whatever
    end
  end

end
