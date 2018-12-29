defmodule SindubioWeb.PageController do
  use SindubioWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
