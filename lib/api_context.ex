defmodule ApiContext do

    alias RestApi.User
    import Ecto.Query, warn: false
    import Ecto

    def checkIfUserExists(emailId) do
    user = User
        |> where([user], user.email == ^emailId)
        |> Repo.one()

        not is_nil(user)
    end

    def registerUser(parameters) do
        if Map.has_key?("email") and Map.has_key?("password") do
            userMap = %{
                email: parameters["email"],
                password: parameters["password"],
                fullName: parameters["fullName"],
                age: parameters["age"],
                inserted_at: DateTime.utc_now(),
                updated_at: DateTime.utc_now()
            }
            case User.changeset(%User{}, userMap)  |> Repo.insert() do
                {:ok, struct} -> {:ok, struct}
                {:error, changeset} -> {:error, changeset}
            end
        else
            {:error, "Missing Email or Password field in input"}
        end
    end
end