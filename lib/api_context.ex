defmodule ApiContext do


    import Ecto.Query, warn: false
    import Ecto
    alias RestApi.Repo 
    alias RestApi.User
    alias RestApi.TopicOfInterest
    alias RestApi.UserTopicsRelationship

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

    defp checkIfUserHasAnyTopics(userId) do
        Repo.exists(from userTopic in UserTopicsRelationship, where: userTopic.userId == ^userId)
    end

    defp getAllUserTopics(userId) do
        queryForAllTopicIds = 
            from userTopic in UserTopicsRelationship, 
            where: userTopic.userId == ^userId,
            select: userTopic.topicId

        topicsIds = Repo.all(queryForAllTopicIds)

    end

    def getAllUserRecords() do
        try do 
            allUsers = 
                User
                |> Repo.all()
                # |> Repo.preload(:topics_of_interests)

            allUsers
            |> Enum.map(fn user -> 
                case checkIfUserHasAnyTopics(user.id) do
                    false -> 
                        Map.put(user, :topic_of_interests, [])
                    true -> 
                        getAllUserTopics(user.id)
                end
            end)
            {:ok, records}
        catch 
            exception -> {:error, exception}
        end
    end

    defp validateType(val) when is_binary(val) do
        {converted, _} = Integer.parse(val)
        converted
    end

    defp validateType(val) when is_number(val), do: val

    defp validateType(_), do: raise "Invalid Type for value"

    def registerUser(parameters) do
        if Map.has_key?(parameters, "email") and Map.has_key?(parameters, "password") do
             %User{
                email: parameters["email"],
                password: parameters["password"],
                fullName: parameters["fullName"],
                age: validateType(parameters["age"]),
                inserted_at: currentTime(),
                updated_at: currentTime()
            }
            |> Repo.insert() 
        else
            {:error, "Missing Email or Password field in input"}
        end
    end

    def addTopicOfInterestForUser(topicId, userId) do
        try do 
            case Repo.get_by(TopicOfInterest, id: topicId) do
                nil -> 
                    {:error, "Topic with given Id doesnt exist"}

                topic -> 
                    %UserTopicsRelationship{
                        userId: validateType(userId),
                        topicId: validateType(topicId),
                        inserted_at: currentTime(),
                        updated_at: currentTime()
                    }
                    |> Repo.insert()
            end
        catch 
            exception -> 
                {:error, exception}
        end
    end

    defp currentTime() do
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)
    end
end