defmodule RestApi.Plug.Authentication do
    import Plug.Conn 

    def init(opts), do: opts

    def call(conn, _opts) do
        if authenticated?(conn) do
            conn
        else
            conn
            |> send_resp(401, "")
            |> halt()
        end
    end

    defp authenticated?(conn) do
        token = conn |> Plug.Conn.get_req_header("jwt_token") |> List.first()
        try do
            case RestApi.Guardian.decode_and_verify(token) do
                {:ok, claims} -> 
                        claims

                {:error, %Guardian.MalformedReturnValueError{message: message}} -> 
                    conn
                    |> send_resp(500, "Auth Token not found or is invalid. ")
                    |> halt()
            end
        catch
            exception -> 
                conn
                |> send_resp(500, to_string(exception))
                |> halt()
        end
    end
end