defmodule RestApiWeb.UserController do
    use RestApiWeb, :controller
    alias ApiContext 

    def deleteUserByEmailId(conn, params) do
        emailId = params["email"]
        case ApiContext.checkIfUserExists(emailId) do
            true -> 
                case ApiContext.deleteUserByEmailId(emailId) do
                    {:ok, _} -> send_resp(conn, 200, "Delete User with email id #{emailId}")
                    {:error, reason} -> send_resp(conn, 200, reason)
                end
            false -> 
                send_resp(conn, 500, "User does not exist !")
        end
    end
    
    def updateUserDetails(conn, params) do
        emailId = params["email"]
        case ApiContext.checkIfUserExists(emailId) do
            true -> 
                case ApiContext.updateUserDetails(params) do
                    :ok -> send_resp(conn, 200, "Updated User details with email #{emailId}")
                    {:error, reason} -> send_resp(conn, 500, reason)
                end
            
            false -> 
                send_resp(conn, 500, "User does not exist !")
        end
    end

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

    def removeUserAndTopicAssociation(conn, parameters) do
        userId = parameters["user_id"]
        topicIdOrName = parameters["topic_id_or_name"]

        case ApiContext.checkUserbyId(userId) do
            true -> 
                case ApiContext.removeUserAndTopicAssociation(userId, topicIdOrName) do
                    :ok -> send_resp(conn, 200, "Association between User Id #{userId} and topicId #{topicIdOrName} successfully removed ! ")

                    {:error, reason} -> send_resp(conn, 500, reason)
                end
            false -> 
                send_resp(conn, 500, "User does not exist ! ")
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

    def getListOfEventsForUser(conn, params) do
        emailId = params["email"]
        case ApiContext.checkIfUserExists(emailId) do
            true -> 
                case ApiContext.getAllEventsForCurrentUser(emailId) do
                    {:ok, allEvents} -> render(conn, "all_events.json", %{allEvents: allEvents, emailId: emailId})
                    {:error, reason} -> send_resp(conn, 500, reason)
                end

            false -> 
                send_resp(conn, 500, "User with email #{emailId} does not exist")
        end
    end
end