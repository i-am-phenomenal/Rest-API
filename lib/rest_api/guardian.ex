defmodule RestApi.Guardian do
    use Guardian , otp_app: :rest_api 
    alias ApiContext

    # Used to encode the user into a token
    def subject_for_token(user, _claims) do
        {:ok, to_string(user.id)}
    end

    # Used to decode a user from a token
    def resource_from_claims(%{"sub" => id}) do
        user = ApiContext.getUserById(id)
        {:ok, user}
    rescue
        Ecto.NoResultsError -> {:error, :resource_not_found}
    end
end