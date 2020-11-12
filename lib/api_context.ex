defmodule ApiContext do

    alias RestApi.User
    alias RestApi.TopicOfInterest
    import Ecto.Query, warn: false
    import Ecto
    alias RestApi.Repo 

    def checkIfUserExists(emailId) do
        user = User
            |> where([user], user.email == ^emailId)
            |> Repo.one()

        not is_nil(user)
    end

    def checkUserbyId(userId) do
        user = User
            |> where([user], user.id == ^userId)
            |> Repo.one()

        not is_nil(user)
    end

    defp validateType(ageVal) when is_binary(ageVal) do
        {converted, _} = Integer.parse(ageVal)
        converted
    end

    defp validateType(ageVal) when is_number(ageVal), do: ageVal

    defp validateType(_), do: raise "Invalid Type for Age"

    def registerUser(parameters) do
        if Map.has_key?(parameters, "email") and Map.has_key?(parameters, "password") do
             %User{
                email: parameters["email"],
                password: parameters["password"],
                fullName: parameters["fullName"],
                age: validateType(parameters["age"]),
                inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
                updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
            }
            |> Repo.insert() 
        else
            {:error, "Missing Email or Password field in input"}
        end
    end

    def addTopicOfInterestForUser(params, userId) do
        if Map.has_key?(params, "topicName") and Map.has_key?(params, "shortDesc") do
            try do 
                TopicOfInterest.changeset(
                    %TopicOfInterest{},
                    %{
                        topicName: params["topicName"],
                        shortDesc: params["shortDesc"]
                    }
                )
                |> Repo.insert()
            catch 
                exception -> 
                    {:error, exception}
            end
        else 
            {:error, "One or more parameters are missing"}
        end
    end
end