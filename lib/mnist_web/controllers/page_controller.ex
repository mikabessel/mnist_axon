defmodule MnistWeb.PageController do
  use MnistWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
