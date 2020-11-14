defmodule RestApiWeb.PageController do
  use RestApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def protected(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    send_resp(conn, 200, user)
  end
end
