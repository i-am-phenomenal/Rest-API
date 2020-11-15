defmodule RestApiWeb.EventController do
    use RestApiWeb, :controller
    alias ApiContext

    def addUserToEvent(conn, params) do
        emailId = params["email"]
        case ApiContext.checkIfUserExists(emailId) do
            true -> 
                case ApiContext.addUserEventAssociationByEmail()
            false -> 
                send_resp(conn, 500, "User does not exist ! ")
        end
    end
end