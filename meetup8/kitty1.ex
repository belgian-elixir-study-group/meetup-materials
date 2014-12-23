# translated from Fred Hébert's erlang code

defmodule Cat do
  defstruct name: "", color: :green, description: nil
end

defmodule KittyShop do

  #### Client API ####

  def start_link do
    spawn_link &( KittyShop.init/0 )
  end

  # synchronous call
  def order_cat(pid, name, color, description) do

    # Monitors are unidirectional
    # Monitors are what you want when a process wants to know what's going on with a
    # second process, but neither of them really are vital to each other.
    # http://learnyousomeerlang.com/errors-and-processes#monitors
    ref = Process.monitor pid

    message = {:order, name, color, description}

    send pid, {self, ref, message}

    receive do
      {^ref, cat = %Cat{}} ->
        Process.demonitor(ref)
        cat
      {'DOWN', _ref, :process, _pid, reason} ->
        :erlang.error reason
    after
      5000 -> :erlang.error :timeout
    end

  end

  # asynchronous call
  def return_cat(pid, cat = %Cat{}) do
    message = {:return, cat}
    send(pid, message)
  end

  # synchronous call
  def close_shop(pid) do

    ref = Process.monitor pid

    send(pid, {self, ref, :terminate})

    receive do
      {^ref, :ok} ->
        Process.demonitor(ref)
        :ok

      {'DOWN', ^ref, :process, _pid, reason} ->

        :erlang.error reason

    after 5000 ->
        :erlang.error :timeout
    end

  end


  ### Server ###

  def init, do: loop([])

  def loop(cats) do
    receive do

      {reply_to_pid, ref, {:order, name, color, description}} ->
        case cats do
          [] ->
            new_cat = %Cat{name: name, color: color, description: description}
            send(reply_to_pid, {ref, new_cat})
            loop cats

          [first_cat | other_cats]  ->
            send(reply_to_pid, {ref, first_cat})

            loop(other_cats)
        end


      {:return, cat = %Cat{}} ->
        loop [cat | cats]


      {reply_to_pid, ref, :terminate} ->

        cats
        |> Enum.each &( IO.puts "#{&1.name} is set free" )

        send(reply_to_pid, {ref, :ok})

      unknown ->
        IO.puts "Message not understood: #{unknown}"
        loop(Cats)

    end
  end
end


defmodule KittyShopTest do


  def run do
    kitty_shop_pid = KittyShop.start_link

    cat0 = KittyShop.order_cat(kitty_shop_pid, "Bandit", "white", "likes to pee into shoes")

    IO.inspect cat0


    cat1 = KittyShop.order_cat(kitty_shop_pid, "Carl", "brown", "loves to burn bridges")

    IO.inspect cat1

    cat2 = KittyShop.order_cat(kitty_shop_pid, "Jimmy", "orange", "loves to purrrr")

    IO.inspect cat2

    KittyShop.return_cat(kitty_shop_pid, cat2)

    cat3 = KittyShop.order_cat(kitty_shop_pid, "Lucas", "black", "eats a lot")

    KittyShop.return_cat(kitty_shop_pid, cat1)
    KittyShop.return_cat(kitty_shop_pid, cat0)

    IO.inspect cat3 # oops :(

    KittyShop.close_shop(kitty_shop_pid)

    :ok
  end

end


KittyShopTest.run