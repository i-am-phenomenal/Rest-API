defmodule ApiContext do

    import Ecto.Query, warn: false
    import Ecto
    alias RestApi.Repo 
    alias RestApi.User
    alias RestApi.TopicOfInterest
    alias RestApi.UserTopicsRelationship
    alias Argon2

    def getUserById(id) do
        Repo.get_by(User, id: id)
    end

    def authenticateUser(emailId, plainTextPassword) do
        userQuery = 
            from user in User, 
            where: user.emailId == ^emailId and user.password == ^plainTextPassword
         
        case Repo.one(userQuery) do
            nil -> 
                Argon2.no_user_verify()
                {:error, :invalid_credentials}
            user -> 
                if Argon2.verify_pass(plainTextPassword, user.password) do
                    {:ok, user}
                else 
                    {:error, :invalid_credentials}
                end
        end
    end

    def addNewTopicOfInterest(params) do
        if checkIfAllFieldsArePresent?(params) do
            case checkIfTopicAlreadyPresent?(String.downcase(params["topic_name"])) do
                true -> 
                    {:error, "Topic Already present"}
                false -> 
                    %TopicOfInterest{
                        topicName: params["topic_name"],
                        shortDesc: params["short_desc"]
                    }
                    |> Repo.insert()
                    :ok
            end
        else 
            {:error, "Invalid format for Params. One or more required fields are missing !"}
        end
    end

    defp checkIfTopicPresentById?(topicId) do
        case Repo.get_by(TopicOfInterest, id: topicId) do
            nil -> false
            _topic -> true
        end
    end

    defp checkIfTopicAlreadyPresent?(topicName) do
        allTopicNames = 
            (from topic in TopicOfInterest, 
            select: topic.topicName)
            |> Repo.all()
            |> Enum.map(& String.downcase(&1))
            
        topicName in allTopicNames
    end

    def getAllTopicsOfInterests() do
        try do
            {:ok, Repo.all(TopicOfInterest) }
        catch 
            exception -> 
                {:error, exception}
        end
    end

    defp getTopicIdByName(topicName) do
        topicId = 
            (
                from topic in TopicOfInterest,
                where: topic.topicName == ^topicName,
                select: topic.id
            )
            |> Repo.one()

        if is_nil(topicId) do
            raise "There is no such Topic present, please make sure you enter the proper names because it is case sensitive"
        else 
            topicId
        end
    end

    defp removeUserTopicRelationshipById(topicId, userId) do
        (
            from userTopicRelationship in UserTopicsRelationship,
            where: userTopicRelationship.userId == ^userId and userTopicRelationship.topicId == ^topicId,
            select: userTopicRelationship
        )
        |> Repo.one()
        |> Repo.delete()
    end

    defp removeUserTopicRelationship(topicName, userId) do
        topicId = getTopicIdByName(topicName)
        query = 
            from userTopicRelationship in UserTopicsRelationship,
            where: userTopicRelationship.userId == ^userId and userTopicRelationship.topicId == ^topicId

        Repo.delete(query)
    end

    def removeUserAndTopicAssociation(userId, topicIdOrName) do
        case Integer.parse(topicIdOrName) do
            # Means that we have topic name
            :error -> 
                if checkIfTopicAlreadyPresent?(topicIdOrName) do
                    removeUserTopicRelationship(topicIdOrName, userId)
                    :ok
                else
                    {:error, "Given Topic is not present"}
                end
                # Means  we have topic id
            {topicId, ""} -> 
                if checkIfTopicPresentById?(topicId) do
                    removeUserTopicRelationshipById(topicId, userId)
                    :ok
                else 
                    {:error, "Given topic id does not exist "}
                end
        end
    end

    defp checkIfAllFieldsArePresent?(params) do
        Map.has_key?(params, "topic_name") and Map.has_key?(params, "short_desc")
    end

    def getUsersTopicsOfInterests(userId) do
        case checkIfUserHasAnyTopics(userId) do
            true -> {:ok, getAllUserTopics(userId)}
            false -> {:ok, "User does not have any topics of interests yet !"}
        end
    end

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
        Repo.exists?(from userTopic in UserTopicsRelationship, where: userTopic.userId == ^userId)
    end

    defp getAllUserTopics(userId) do
        queryForAllTopicIds = 
            from userTopic in UserTopicsRelationship, 
            where: userTopic.userId == ^userId,
            select: userTopic.topicId

        Repo.all(queryForAllTopicIds)
        |> Enum.map(fn topicId -> 
            topicQuery = 
                from topic in TopicOfInterest, where: topic.id == ^topicId
            Repo.one(topicQuery)
        end)
    end

    def getAllUserRecords() do
        try do 
            allUsers = 
                User
                |> Repo.all()
            
            userRecords = 
                allUsers
                |> Enum.map(fn user -> 
                    case checkIfUserHasAnyTopics(user.id) do
                        false -> 
                            Map.put(user, :topics, [])
                        true -> 
                            Map.put(user, :topics, getAllUserTopics(user.id))
                    end
                end)
            {:ok, userRecords}
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