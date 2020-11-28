defmodule RestApiWeb.AdminTopicEventController do
    use RestApiWeb, :controller
    alias ApiContext

    def post(conn, params) do
        case ApiContext.createTopicEventRelationship(params) do
            :ok -> send_resp(conn, 200,  "Relationship between topic and event created successfully !")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
