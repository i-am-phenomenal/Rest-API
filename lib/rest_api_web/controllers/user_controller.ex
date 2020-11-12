defmodule RestApi.UserController do
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
end