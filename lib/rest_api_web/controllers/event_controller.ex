defmodule RestApiWeb.EventController do
    use RestApiWeb, :controller
    alias ApiContext

    def addUserToEvent(conn, params) do
        emailId = params["email"]
        case ApiContext.checkIfUserExists(emailId) do
            true -> 
                case ApiContext.addUserEventAssociationByEmail(params) do
                    :ok -> send_resp(conn, 200, "User has accepted the invite !")

                    {:error, reason} -> send_resp(conn, 500, reason)
                end
            false -> 
                send_resp(conn, 500, "User does not exist ! ")
        end
    end

    def removeUserFromEvent(conn, params) do
       emailId = params["email"]
       case ApiContext.checkIfUserExists(emailId) do
        true -> 
            case ApiContext.removeUserFromEvent(params) do
                :ok -> send_resp(conn, 200, "User with email Id #{emailId} has been removed from the event !")                
                {:error, reason} -> send_resp(conn, 500, reason)
            end
        false -> 
            send_resp(conn, 500, "User does not exist ! ")
       end
    end

    def getRSVPCountsForAnEvent(conn, params) do
        case ApiContext.getRSVPCountsForAnEvent(params) do
            {:ok, rsvpCounts }-> render(conn, "rsvp_count.json", count: rsvpCounts)

            {:error, reason} -> send_resp(conn, 200, reason)
        end
    end

    def getCancelledRSVPCountsForEvent(conn, params) do
        case ApiContext.getCancelledRSVPCountsForAnEvent(params) do
            {:ok, rsvpCounts }-> render(conn, "cancelled_rsvp_count.json", count: rsvpCounts)

            {:error, reason} -> send_resp(conn, 200, reason)
        end
    end

    def listInterestedUsersForEvent(conn, params) do
        case ApiContext.getInterestedUsersForEvent(params) do
            {:ok, users} -> render(conn, "users_for_event.json", users: users)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end

    def listOfCancelledUsersForEvent(conn, params) do
        case ApiContext.getUsersWhoRejectedEvent(params) do
            {:ok, users} -> render(conn, "users_for_event.json", users: users)

            {:error, reason} -> send_resp(conn, 500, reason)
        end
    end
end