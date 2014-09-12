# running as a script:
$ elixir foo.exs

# REPL:
$ iex

# compiling
$ elixirc foo.ex

# compiling from iex
$ c("foo.ex")

# documentation directly from iex:
$ h(Enum)

docs:  http://elixir-lang.org/docs/stable/elixir/

# == Types ==

42
34.2

:an_atom

~r{^[Hh]ello$}

1..23

IO.inspect self



{:ok, "foo", "baz"}


[1, 2, "three"]


[ 3 | [] ]

[1 | [2 | [3|[]]]]

[1, 2, 3]


[1,2,3] ++ [4,5,6]

1 in [1, 2, 3 ,4]

"foo" <> "baz"  #=> "foobaz"

"Hello Mr #{lastname}"


[ {:name, "Olivier"}, {:age, 42}, {:eats, "beans"} ]
[ name: "Olivier", age: 42, eats: "beans" ]


MagicWand.save world, [ {:immediately, true}, {:ark, "Noah's"} ]

MagicWand.save world, immediately: true, ark: "Noah's"


states = %{ "AL" => "Alabama", "WI" => "Wisconsin" }

states["AL"]

person = %{ name: "Peter", surname: "Wisconsin", age: 26 }

person[:name]
person.name


another_person = %{ person | age: 27 }

# == Pattern matching ==

{:ok, c, d} = {:ok, 10, 42}

{:ok, c, _} = {:ok, 10, 42}

[head | tail] = [1, 2, 3, 4]

[head, head2 | tail] = [1, 2, 3, 4]

[head, head2 | tail] = [1, 2, 3, 4]


a = 4
{:ok, a, b} = {:ok, 56, 0}
{:ok, ^a, b} = {:ok, 56, 0} # MatchError !
{:ok, ^a, b} = {:ok, 4, 0}

# == Anonymous functions ==

fn (x, y) ->
  x + y
end

what_is_it = fn
  [] -> "an empty list"
  [_head | [] ] -> "a  list with one element"
  [_head |  _ ] -> "a  list with more than one element"
  {_, _} -> "a tuple with 2 elements"
  _ -> "I don't know, leave me alone!"
end

sum = fn(a, b) -> a + b end
sum = &( &1 + &2 )

# == Modules and functions ==

defmodule Foo do
  def say_hello(name) do
    "Hello, #{name}"
  end
end

defmodule Foo do
  def say_hello(name), do: "Hello, #{name}"
end

Foo.say_hello("Jack")

# Multiple clauses
defmodule Factorial do
  def of(0), do: 1
  def of(n), do: n * of(n-1)
end

# Guards
defmodule Factorial do
  def of(0), do: 1
  def of(n) when is_integer(n) and when n > 0 do
    n * of(n-1)
  end
end

# A private function
defmodule Foo do
  defp a_private_function do
    ...
  end
end

# Modules inside modules
defmodule Outer do
  defmodule Inner do
    def inner_func do
    end
  end

  def outer_func do
    Inner.inner_func
  end
end

Outer.outer_func
Outer.Inner.inner_func

# import

defmodule Mix.Tasks.Doctest do
  def run do
  end
end

defmodule ImportExample do

  import Mix.Tasks.Doctest
  # import Mix.Tasks.Doctest, only: [ run: 0 ]

  def test do
    run()
  end
end

# alias

defmodule AliasExample do

  alias Mix.Tasks.Doctest, as: Doctest

  def test do
    Doctest.run()
  end
end

#  non-tail-recursive vs. tail-recursive

# non-tail-recursive: the stack grows
defmodule Factorial do
  def of(0), do: 1

  def of(n)  when n > 0 do
    n * of(n-1)
  end

end


# tail-recursive: Erlang can optimize such a function in a such a way that the stack won't grow
defmodule Factorial do

  def of(n) when n > 0 do
    calculate(n, 1)
  end

  defp calculate(0, accu), do: accu

  defp calculate(n, accu) do
    calculate(n - 1, accu * n)
  end

end
