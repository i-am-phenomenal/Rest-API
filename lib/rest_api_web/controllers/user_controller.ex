defmodule RestApiWeb.UserController do
    use RestApiWeb, :controller
    alias ApiContext 

    def signUp(conn, parameters) do
        case ApiContext.checkIfUserExists(parameters["email"]) do
            true -> send_resp(conn, 200, "User with given id already exists")

            false -> 
                case ApiContext.registerUser(parameters) do
                    {:ok, resp} -> render(conn, "user_sign_up.json", resp: resp)

                    {:error, reason} -> send_resp(conn, 500, reason)
                end
        end
    end

    @doc """
    Made this API for testing purposes
    """

    def getAllUsers(conn, _params) do
        case ApiContext.getAllUserRecords() do
            {:ok, userRecords} -> render(conn, "all_user_records.json", userRecords: userRecords)
            
            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def addTopicOfInterest(conn, params) do
        userId = params["user_id"]
        topicId = params["topic_id"]
        case ApiContext.checkUserbyId(userId) do
            true -> case ApiContext.addTopicOfInterestForUser(topicId, userId) do
                {:ok, topic} -> render(conn, "user_topic_of_interest.json", resp: topic)
                {:error, reason} -> send_resp(conn, 500, reason)
            end

            false -> send_resp(conn, 500, "User does not exist !")
        end
    end
end