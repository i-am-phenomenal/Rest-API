defmodule RestApi.SessionController do
    use RestApiWeb, :controller

    alias RestApi.{User, Guardian, ApiContext}

    def login(conn, %{"user" => %{"email" => emailId, "password" => password}}) do
        ApiContext.authenticateUser(emailId, password)
        |> loginReply(conn)
    end

    defp loginReply({:ok, user}, conn) do
        conn
        |> put_flash(:info, "Welcome")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/protected")
    end

    defp loginReply({:error, reason}, conn) do
        conn
        |> put_flash(:error, to_string(reason))
    end
end
