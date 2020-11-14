defmodule RestApiWeb.SessionController do
    use RestApiWeb, :controller

    alias RestApi.{User, Guardian}

    alias ApiContext

    def new(conn, params) do
        emailId = params["email"]
        plainTextPassword = params["password"]
        maybeUser = Guardian.Plug.current_resource(conn) 
        if maybeUser do
            redirect(conn, to: "/api/protected")
        else 
            send_resp(conn, 200, "ELSE CLAUSE")
        end
    end

    def login(conn, %{"user" => %{"email" => emailId, "password" => password}}) do
        ApiContext.authenticateUser(emailId, password)
        |> loginReply(conn)
    end

    defp loginReply({:ok, user}, conn) do
        {:ok, token, claims} = RestApi.Guardian.encode_and_sign(user)
        conn
        |> put_flash(:info, "Welcome")
        |> Guardian.Plug.sign_in(user)
        |> send_resp(200, token)
    end

    defp loginReply({:error, reason}, conn) do
        conn
        |> put_flash(:error, to_string(reason))
        |> new(%{})
    end
end
