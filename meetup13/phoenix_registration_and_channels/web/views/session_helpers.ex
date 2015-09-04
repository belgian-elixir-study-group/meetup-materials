defmodule Swotter.SessionHelpers do

  def logged_in?(conn) do
    conn.assigns[:current_user]
  end

  def logged_out?(conn) do
    ! logged_in?(conn)
  end

  def logged_in?(conn, func) do
    if logged_in?(conn), do: func.()
  end

  def logged_out?(conn, func) do
    if logged_out?(conn), do: func.()
  end

  def logged_in?(conn, func, func_out) do
    if logged_in?(conn), do: func.(), else: func_out.()
  end

end
