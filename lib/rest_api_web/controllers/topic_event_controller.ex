defmodule RestApiWeb.TopicEventController do
    use RestApiWeb, :controller
    alias ApiContext

    def addUserTopicToEvent(conn, params) do
        currentUser = Guardian.Plug.current_resource(conn)
        case ApiContext.addUserTopicToEvent(currentUser, params) do
            {:ok, addedDetails} -> send_resp(conn, 200, "")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
end