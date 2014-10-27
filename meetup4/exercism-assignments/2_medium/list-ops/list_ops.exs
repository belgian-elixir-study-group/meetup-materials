defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically important`) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count([]) do

  end

  @spec reverse(list) :: list
  def reverse(list) do

  end

  @spec map(list, (any -> any)) :: list
  def map([], f) do

  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], f) do

  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, f) do

  end

  @spec append(list, list) :: list
  def append(a, []) do

  end


  @spec concat([[any]]) :: [any]
  def concat([]) do

  end

end
