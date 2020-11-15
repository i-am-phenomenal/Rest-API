defmodule RestApiWeb.AdminController do
    use RestApiWeb, :controller
    alias ApiContext

    def addNewEvent(conn, params) do
        case ApiContext.addNewEvent(params) do
            {:ok, event} -> render(conn, "event.json", event: event)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
end