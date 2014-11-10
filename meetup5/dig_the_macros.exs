defmodule DigTheMacros do


  @doc """

    Here is your typical macro:

    defmacro(argument1, argument2, do: quoted_code_of_the_do_block)
      ...
      quote do  # start parsing code into AST
        ...
        ...
        unquote do # pause parsing  into AST, just append what's inside as AST (in other words: what is inside of `unquote do end` should be valid AST)
          ...
        end # ok, go on parsing code into AST
        ...
      end
    end

  """

  def timestamp do
    {megaseconds, seconds, microseconds} = :erlang.now()
    megaseconds * 1000000000000 + seconds * 1000000 + microseconds
  end


  @doc """
    just execute the given code, but before executing print the AST
  """
  defmacro print_AST_and_execute(quoted_code) do

  end


  @doc """
    print the timestamp before executing the code,
    print the timestamp after executing the code,
    return the correct value of the expression
  """
  defmacro print_timestamps_before_and_after_execution(quoted_code) do

  end

  @doc """
    similar to print_timestamps_before_and_after_execution,
    but instead of printing calculate the time spent on execution of the code
    return a tuple {time_spent, result_of_the_expression}
  """
  defmacro simple_benchmark(do: quoted_code) do

  end


  @doc """
    takes the AST of a simple 2 argumet call like `2 - 4` or `2 / 4`
    and rewrite it by swapping the arguments
  """
  defmacro reverse_arguments( do: {op, context, [arg1, arg2]} ) do

  end

end
