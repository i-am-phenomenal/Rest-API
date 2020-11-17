defmodule RestApiWeb.AdminController do
    use RestApiWeb, :controller
    alias ApiContext

    def adminLogin(conn, %{"email" => emailId, "password" => password}) do
        ApiContext.authenticateAdminCredentials(emailId, password)
        |> loginReply(conn)
    end

    defp loginReply({:ok, user}, conn) do
        {:ok, token, claims} = RestApi.Guardian.encode_and_sign(user, %{}, ttl: {1, :day})
        conn
        |> put_flash(:info, "Welcome")
        |> Guardian.Plug.sign_in(user)
        |> send_resp(200, token)
    end

    defp loginReply({:error, reason}, conn) do
        conn
        |> put_flash(:error, to_string(reason))
        |> halt()
    end

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

    def updateAnEvent(conn, params) do
        case ApiContext.updateAnEvent(params) do
            {:ok, updatedEvent} -> render(conn, "event.json", event: updatedEvent)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def deleteAnEvent(conn, params) do
        case ApiContext.deleteAnEvent(params) do
            :ok -> send_resp(conn, 200, "Deleted Event successfully !")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def addTopicOfInterest(conn, params) do
        case ApiContext.addTopicOfInterest(params) do
            {:ok, addedTopic} -> render(conn, "topic.json", topic: addedTopic)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def updateTopicOfInterest(conn, params) do
        case ApiContext.updateTopicOfInterest(params) do
            {:ok, updatedTopic} -> render(conn, "topic.json", topic: updatedTopic)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def deleteTopicOfInterest(conn, params) do
        topicNameOrId = params["topicNameOrId"]
        case ApiContext.deleteTopicOfInterest(topicNameOrId) do
            :ok -> send_resp(conn, 200, "Deleted the topic with name or id #{topicNameOrId} ")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
end