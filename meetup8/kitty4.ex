# translated from Fred Hébert's erlang code

defmodule Cat do
  defstruct name: "", color: :green, description: nil
end


defmodule MyGenericServer do

  #### Client API ####

  def call(pid, message) do

    ref = Process.monitor pid

    send pid, {:sync, self, ref, message}

    receive do
      {^ref, reply} ->
        Process.demonitor(ref)
        reply
      {'DOWN', _ref, :process, _pid, reason} ->
        :erlang.error reason
    after
      5000 -> :erlang.error :timeout
    end
  end

  def cast(pid, message) do
    send(pid, {:async, message})
  end

  ### Server ###

  # !!!
  def loop(module, state) do

    receive do

      {:async, message} ->
        new_state = module.handle_cast(message, state)
        loop(module, new_state)

      {:sync, reply_to_pid, ref, message} ->

        new_state = module.handle_call(message, {reply_to_pid, ref}, state)
        loop(module, new_state)

    end
  end

end

defmodule KittyShop do

  #### Client API ####

  def start_link do
    spawn_link &( KittyShop.init/0 )
  end

  # synchronous call
  def order_cat(pid, name, color, description) do
    MyGenericServer.call(pid, {:order, name, color, description} )
  end

  # asynchronous call
  def return_cat(pid, cat = %Cat{}) do
    MyGenericServer.cast pid, {:return, cat}
  end

  # synchronous call
  def close_shop(pid) do
    MyGenericServer.call(pid, :terminate)
  end


  ### Server ###

  def init do
    # !!!
    MyGenericServer.loop(__MODULE__, [])
  end


  # !!!
  def handle_call({:order, name, color, description}, {reply_to_pid, ref}, cats) do
    case cats do

      [] ->
        new_cat = %Cat{name: name, color: color, description: description}
        send(reply_to_pid, {ref, new_cat})
        cats

      [first_cat | other_cats]  ->
        send(reply_to_pid, {ref, first_cat})
        other_cats

    end
  end

  # !!!
  def handle_call(:terminate, {reply_to_pid, ref}, cats) do

    cats
    |> Enum.each &( IO.puts "#{&1.name} is set free" )

    send(reply_to_pid, {ref, :ok})
    exit(:normal)
  end

  # !!!
  def handle_cast({:return, cat = %Cat{}}, cats) do
    [cat | cats]
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