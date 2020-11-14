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
            {:ok, claims} =     RestApi.Guardian.decode_and_verify(token)
            claims
        catch
            exception -> 
                conn
                |> send_resp(500, to_string(exception))
                |> halt()
        end
    end
end