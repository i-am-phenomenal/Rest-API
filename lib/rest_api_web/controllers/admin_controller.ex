defmodule RestApiWeb.AdminController do
    use RestApiWeb, :controller
    alias ApiContext

    def addNewEvent(conn, params) do
        case ApiContext.addNewEvent(params) do
            {:ok, event} -> render(conn, "event.json", event: event)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def listAllEvents(conn, _params) do
        case ApiContext.getAllEventsForAdmin() do
            {:ok, events} -> render(conn, "all_events.json", events: events)

            {:ok, []} -> send_resp(conn, 200, "There are no events in the database yet !")
        end
    end
end