defmodule RestApiWeb.TopicController do
    use RestApiWeb, :controller
    alias ApiContext

    def getCurrentUserTopicsOfInterests(conn, _params) do
        currentUser = Guardian.Plug.current_resource(conn)
        case ApiContext.getUsersTopicsOfInterests(currentUser.id) do
            {:ok, topics} -> 
                    if is_binary(topics) do
                        send_resp(conn, 200, topics)
                    else 
                        render(conn, "user_topics.json", topics: topics)
                    end
            {:error, reason} -> 
                    send_resp(conn, 500, reason)
        end
    end

    def getUsersTopicsOfInterests(conn, params) do
        userId = params["user_id"]
        case ApiContext.checkUserbyId(userId) do
            true -> case ApiContext.getUsersTopicsOfInterests(userId) do
                {:ok, topics} -> 
                        if is_binary(topics) do
                            send_resp(conn, 200, topics)
                        else
                            render(conn, "user_topics.json", topics: topics)
                        end
                {:error, reason} -> send_resp(conn, 500, reason)
            end
            false -> 
                send_resp(conn, 500, "User does not exist !")
        end
    end

    def getAllTopics(conn, _params) do
        case ApiContext.getAllTopicsOfInterests() do
            {:ok, allTopics} -> render(conn, "user_topics.json", topics: allTopics)
            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def addNewTopicOfInterest(conn, params) do
        case ApiContext.addNewTopicOfInterest(params) do
            :ok -> send_resp(conn, 200, "Added New Topic")
            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def addTopicOfInterestForCurrentUser(conn, params) do
        currentUser = Guardian.Plug.current_resource(conn)
        case ApiContext.addNewTopicForCurrentUser(currentUser, params) do
            :ok -> send_resp(conn, 200, "Added New Topic for user #{currentUser.fullName}")

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
end