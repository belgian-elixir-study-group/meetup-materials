defmodule Swotter.PageController do
  use Swotter.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
