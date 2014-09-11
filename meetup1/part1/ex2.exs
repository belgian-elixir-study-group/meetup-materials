# Write a function that takes three arguments.
# If the first two are zero, return “FizzBuzz”.
# If the first is zero, return “Fizz”.
# If the second is zero return “Buzz”.
# Otherwise return the third argument.

fizz_buzz = fn

end

IO.inspect fizz_buzz.(0, 0, 1) #=> FizzBuzz
IO.inspect fizz_buzz.(0, 100, 21) #=> Fizz
IO.inspect fizz_buzz.(42, 0, 11) #=> Buzz
IO.inspect fizz_buzz.(42, 12, 11) #=> 11

# The operator rem(a, b) returns the remainder after dividing a by b.
# Write a function that takes a single integer (n) and
# which calls the function in the previous exercise,
# passing it rem(n,3), rem(n,5), and n. Call it 7 times with
# the arguments 10, 11, 12, etc.
# You should get “Buzz, 11, Fizz, 13, 14, FizzBuzz, 16”.
# (Yes, it’s a FizzBuzz solution with no conditional logic).

fizz_buzz_without_if = fn n ->

end

IO.inspect fizz_buzz_without_if.(10)
IO.inspect fizz_buzz_without_if.(11)
IO.inspect fizz_buzz_without_if.(12)
IO.inspect fizz_buzz_without_if.(13)
IO.inspect fizz_buzz_without_if.(14)
IO.inspect fizz_buzz_without_if.(15)

# Result:
# "Buzz"
# 11
# "Fizz"
# 13
# 14
# "FizzBuzz"

