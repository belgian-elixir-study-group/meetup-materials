defmodule Swotter.UserSocket do
  use Phoenix.Socket

  channel "user:*",         Swotter.UserChannel
  channel "bank_account:*", Swotter.BankAccountChannel

  transport :websocket, Phoenix.Transports.WebSocket

  @two_weeks 1209600

  def connect(%{"token" => token}, socket) do

    case Phoenix.Token.verify(socket, "user_id", token, max_age: @two_weeks) do
      {:ok, user_id} ->

        IO.inspect "User #{user_id} verified"
        {:ok, assign(socket, :user, user_id)}

      {:error, reason} ->

        IO.inspect "not verified"
        :error

    end
  end

  def id(socket), do: "users_socket:#{user_id(socket)}"

  def user_id(socket), do: socket.assigns[:user]

end
