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
end