defmodule Swotter.UserChannel do

  use Phoenix.Channel

  @msg "msg"

  def join("user:" <> channel_id, auth_msg, socket) do

    IO.inspect "channel_id: #{channel_id}"

    user_id = Swotter.UserSocket.user_id(socket)

    channel_id = String.to_integer(channel_id)

    if user_id == channel_id do
      IO.inspect "user #{user_id} connected to channel"
      {:ok, socket}
    else
      IO.inspect "channel subtopic #{channel_id} is different from user_id in socket #{user_id}"
      :error
    end
  end

  def handle_in("msg", %{"body" => message}, socket) do

    user_id = Swotter.UserSocket.user_id(socket)

    IO.inspect "user #{user_id} sends: #{message}"

    send_to_socket("you said #{message}, and you are #{user_id}", socket)

    {:noreply, socket}
  end

  def send_to_socket(message, socket) do
    push socket, @msg, make_message(message)
  end

  def send_to_all_windows_of_user(message, user_id) do
    Swotter.Endpoint.broadcast! make_topic(user_id), @msg, make_message(message)
  end

  defp make_topic(user_id), do: "user:#{user_id}"

  defp make_message(message), do: %{body: message}

end

# Swotter.UserChannel.send_to_all_windows_of_user("hello there", 2)
