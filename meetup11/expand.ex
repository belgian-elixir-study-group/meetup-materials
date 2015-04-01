# 2 stupid macros calling each other
defmodule UselessMacros do

  defmacro bar(42) do
    quote do
      "the answer"
    end
  end

  defmacro baz(42) do
    quote do
      bar(42)
    end
  end

  defmacro foo(42) do
    quote do
      baz(42)
    end
  end
end


defmodule Baz do

  import UselessMacros

  def run do

    # expand and expand_once are not magic code rewriters
    # they expect the first element in the ast (the top element of the ast tree)
    # tuple to be a macro

    # this
    ast = quote do
      bar(42)
    end

    # is expanded:

    ast |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts

    # this
    ast = quote do
      bar(42) <> "!"
    end

    # is not expanded
    ast |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts

    # because the root of its ast is not bar(), it is <> :
    # IO.inspect ast
    # {:<>, [context: Baz, import: Kernel], [{:bar, [context: Baz, import: UselessMacros], '*'}, "!"]}

    # similarly
    ast = quote do
      if 1, do: bar(42), else: 2
    end

    # only one expansion takes place no matter what you use, expand or expand_once,
    # because the root of result ast is not a macro, it is `case`
    ast |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts

    # the difference between Macro.expand & Macro.expand_all is only seen when there is a
    # macro which returns an AST where the root of the tree is a macro call.

    ast = quote do
      foo(42)
    end

    # only one expansion will just replace a call to foo by a call to baz:
    ast |> Macro.expand_once(__ENV__) |> Macro.to_string |> IO.puts

    # all expansions
    ast |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts

    # Thus, apparently when an elixir program is compiled, Macro.expand()
    # is called on all nodes in the bottom-up order.

  end

end

Baz.run



