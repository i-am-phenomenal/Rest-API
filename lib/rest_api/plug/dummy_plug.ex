defmodule RestApi.Plug.DummyPlug do
    import Plug.Conn

    def init(options), do: options

    def call(conn, _opts) do
        IO.inspect("21222222222222222222222222222222222222")
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "Hello.")
    end
end