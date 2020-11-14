defmodule RestApi.Pipeline do
    use Guardian.Plug.Pipeline,
        otp_app: :rest_api,
        error_handler: RestApi.ErrorHandler,
        module: RestApi.Guardian

    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.LoadResource, allow_blank: true
end