defmodule RestApiWeb.SessionController do
    use RestApiWeb, :controller

    alias RestApi.{User, Guardian}

    alias ApiContext

    def new(conn, params) do
        # changeset = ApiContext.getUserChangeset(%User{})
        emailId = params["email"]
        plainTextPassword = params["password"]
        maybeUser = Guardian.Plug.current_resource(conn) 
        if maybeUser do
            redirect(conn, to: "/api/protected")
        else 
            ApiContext,authenticateUser(emailId, password)
            |> login
            send_resp(conn, 200, "ELSE CLAUSE")
        end
    end

    def login(conn, %{"user" => %{"email" => emailId, "password" => password}}) do
        ApiContext.authenticateUser(emailId, password)
        |> loginReply(conn)
    end

    defp loginReply({:ok, user}, conn) do
        conn
        |> put_flash(:info, "Welcome")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/api/protected")
    end

    defp loginReply({:error, reason}, conn) do
        conn
        |> put_flash(:error, to_string(reason))
        |> new(%{})
    end
end
