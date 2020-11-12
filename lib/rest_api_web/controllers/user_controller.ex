defmodule RestApi.UserController do
    use RestApiWeb, :controller
    alias ApiContext 

    def signUp(conn, parameters) do
        case ApiContext.checkIfUserExists(parameters["email"]) do
            true -> send_resp(conn, 200, "User with given id already exists")

            false -> 
        end
    end
end