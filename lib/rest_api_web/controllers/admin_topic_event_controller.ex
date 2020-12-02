defmodule RestApiWeb.AdminTopicEventController do
    use RestApiWeb, :controller
    alias ApiContext

    def create(conn, params) do
        case ApiContext.createTopicEventRelationship(params) do
            :ok -> send_resp(conn, 200,  "Relationship between topic and event created successfully !")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def index(conn, _) do
        case ApiContext.getAllTopicEventRelationships() do
            {:ok, results } -> render(conn, "all.json", topicEvents: results)
                    
            {:error, reason} -> send_resp(conn, 200, reason)
        end
    end

    def show(conn, params) do
        case ApiContext.getSpecificTopicEventRelationship(params) do
            {:ok, []} -> send_resp(conn, 200, "No event relationships for the given topic !")
            {:ok, topicEventRelationship} -> render(conn, "all.json", topicEvents: topicEventRelationship)

            {:error, reason} -> 
                    send_resp(conn, 500, reason)
        end
    end

    def delete(conn, params) do
        case ApiContext.deleteTopicEventRelationship(params) do
            :ok -> send_resp(conn, 200, "Deleted relationship successfully !")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
end
