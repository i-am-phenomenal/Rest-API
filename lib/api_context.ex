defmodule ApiContext do

    import Ecto.Query, warn: false
    import Ecto
    alias RestApi.Repo 
    alias RestApi.User
    alias RestApi.TopicOfInterest
    alias RestApi.UserTopicsRelationship
    alias RestApi.UserEventRelationship
    alias RestApi.Event
    alias Argon2

    defp getUserIdByEmail(email) do
        userQuery = 
            from user in User,
            where: user.email == ^email,
            select: user.id
            
        Repo.one(userQuery)
    end

    def getEventIdByEventName(eventName) do
        eventQuery = 
            from event in Event,
            where: event.eventName == ^eventName,
            select: event.id

        Repo.one(eventQuery)
    end

    def removeUserFromEvent(params) do
       userId = getUserIdByEmail(params["email"]) 
       eventId = getEventIdByEventName(String.trim(params["eventName"]))

       if is_nil(userId) or is_nil(eventId) do
        {:error, "User or Event does not exist"}
       else
            record =             
                (
                    from userEventRelationship in UserEventRelationship,
                    where: userEventRelationship.userId == ^userId and userEventRelationship.eventId == ^eventId,
                    select: userEventRelationship
                )
                |> Repo.one()

                if is_nil(record) do
                    {:error, "The user has not accepted the event yet. So removing the user from such event is pointless"}
                else 
                    record |> Repo.delete()
                end
            
            :ok
       end
    end

    defp insertUserEventRelationship(userId, eventId) do
        userEventMap = %{
            eventId: eventId,
            userId: userId,
            eventAcceptedOrRejected: "A",
            inserted_at: currentTime(), 
            updated_at: currentTime()
        }

        Repo.insert(
            UserEventRelationship.changeset(%UserEventRelationship{}, userEventMap)
        )
    end

    defp getAllEventsForCurrentUser(userId) do
        query = 
            from userEventRelationship in UserEventRelationship,
            left_join: event in Event,
            on: event.id == userEventRelationship.eventId,
            where: userEventRelationship.userId == ^userId,
            select: event

        Repo.all(query)
    end

    def addEventToMyList(currentUser, nameOrId) do
        userId = currentUser.id
        case Integer.parse(nameOrId) do
            :error ->
                eventId = 
                    nameOrId
                    |> String.trim()
                    |> getEventIdByEventName()
                
                if is_nil(eventId) do
                    {:error, "User Id or Event does not exist"}
                else 
                    insertUserEventRelationship(userId, eventId)
                    {:ok, getAllEventsForCurrentUser(userId)}
                end
            {parsedEventId, _} -> 
                insertUserEventRelationship(userId, parsedEventId)
                {:ok, getAllEventsForCurrentUser(userId)}
        end
    end

    def addUserEventAssociationByEmail(params) do
        userId = getUserIdByEmail(params["email"])
        eventId = getEventIdByEventName(String.trim(params["eventName"]))

        if is_nil(userId) or is_nil(eventId) do
            {:error, "User Id or Event does not exist"}
        else 
            userEventMap = %{
                userId: userId,
                eventId: eventId,
                eventAcceptedOrRejected: "A",
                inserted_at: currentTime(),
                updated_at: currentTime()
            }
            Repo.insert(
                UserEventRelationship.changeset(%UserEventRelationship{}, userEventMap)
            )
            :ok
        end
    end

    defp getCancelledRsvpCountsForEvent(eventId) do
        query = 
            from userEventRelationship in UserEventRelationship,
            where:  userEventRelationship.eventId == ^eventId and
                        userEventRelationship.eventAcceptedOrRejected == "R",
            select: count(userEventRelationship.id)

        Repo.one(query)
    end

    defp getRsvpCountsForEvent(eventId) do
        query = 
            from userEventRelationship in UserEventRelationship,
            where:  userEventRelationship.eventId == ^eventId and
                        userEventRelationship.eventAcceptedOrRejected == "A",
            select: count(userEventRelationship.id)

        Repo.one(query)
    end

    defp getListOfUsersWhoRejectedTheEvent(eventId) do
        query = 
            from userEventRelationship in UserEventRelationship,
            left_join: user in User,
            on: user.id == userEventRelationship.userId,
            where: userEventRelationship.eventId == ^eventId and
                       userEventRelationship.eventAcceptedOrRejected == "R",
            select: user

        Repo.all(query)
    end

    defp getListOfUsersWhoAccepted(eventId) do
        userIdQuery = 
            from userEventRelationship in UserEventRelationship,
            where:  userEventRelationship.eventId == ^eventId and
                        userEventRelationship.eventAcceptedOrRejected == "A",
            select: userEventRelationship.userId
        
        Repo.all(userIdQuery)
        |> Enum.map(fn userId -> 
            userQuery = 
                from user in User,
                where: user.id == ^userId,
                select: user
            Repo.one(userQuery)
        end)
    end

    def getUsersWhoRejectedEvent(params) do
        nameOrId = params["event_name_or_id"]
        case Integer.parse(nameOrId) do
            :error -> 
                eventId = getEventIdByEventName(String.trim(nameOrId))
                if is_nil(eventId) do
                    {:error, "The event with the given id does not exist"}
                else 
                    {:ok, getListOfUsersWhoRejectedTheEvent(eventId)}
                end
            {parsed, _} -> 
                {:ok, getListOfUsersWhoRejectedTheEvent(parsed)}
        end
    end

    def getInterestedUsersForEvent(params) do
        nameOrId = params["event_name_or_id"]
        case Integer.parse(nameOrId) do
            :error -> 
                eventId = getEventIdByEventName(String.trim(nameOrId))
                if is_nil(eventId) do
                    {:error, "The event with the given id does not exist"}

                else 
                    {:ok, getListOfUsersWhoAccepted(eventId)}
                end
            {parsed, _} -> 
                {:ok, getListOfUsersWhoAccepted(parsed)}
        end
    end

    def getCancelledRSVPCountsForAnEvent(params) do
        eventNameOrId = params["event_name_or_id"]
        case Integer.parse(eventNameOrId) do
            :error -> 
                eventId = getEventIdByEventName(String.trim(eventNameOrId))
                    if is_nil(eventId) do
                        {:error, "The Event Name does not exist"}
                    else
                        {:ok, getCancelledRsvpCountsForEvent(eventId)}
                    end
            {parsed, _} -> 
                    {:ok, getCancelledRsvpCountsForEvent(parsed)}
        end
    end

    def getRSVPCountsForAnEvent(params) do
        eventNameOrId = params["event_name_or_id"]
        case Integer.parse(eventNameOrId) do
            :error -> 
                #Means we have event name as arg
                eventId = getEventIdByEventName(String.trim(eventNameOrId))
                if is_nil(eventId) do
                    {:error, "The Event Name does not exist"}
                else
                    {:ok, getRsvpCountsForEvent(eventId)}
                end
            {parsed, _} -> 
                #Means we have Id 
                {:ok, getRsvpCountsForEvent(parsed)}
        end
    end

    def allParametersArePresent?(params) do
        Map.has_key?(params, "eventDescription") and
        Map.has_key?(params, "eventType") and 
        Map.has_key?(params, "eventDate") and 
        Map.has_key?(params, "eventDuration") and 
        Map.has_key?(params, "eventHost") and 
        Map.has_key?(params, "eventLocation") and 
        Map.has_key?(params, "eventName")
    end

    defp parseToInteger(strList) do
        strList
        |> Enum.map(fn val -> 
            {converted, _} = Integer.parse(val)
            converted
        end)
    end

    # strDate should be of the format DD-MM-YYYY
    defp getConvertedEventDate(strDate) do
        [day, month, year] = String.split(strDate, "-") |> parseToInteger()
        date = DateTime.utc_now()
        date = Map.put(date, :day, day)
        date = Map.put(date, :year, year)
        date = Map.put(date, :month, month)
        date = Map.put(date, :hour, 0)
        date = Map.put(date, :minute, 0)
        date = Map.put(date, :second, 0)
        date
    end

    def getAllEventsForAdmin() do
        {:ok, Event |> Repo.all()}
    end

    def addNewEvent(params) do
        if allParametersArePresent?(params) do
            eventMap = %{
                eventDescription: params["eventDescription"],
                eventType: params["eventType"],
                eventDate: getConvertedEventDate(params["eventDate"]),
                eventDuration: params["eventDuration"],
                eventHost: params["eventHost"],
                eventLocation: params["eventLocation"],
                eventName: params["eventName"],
                inserted_at: currentTime(),
                updated_at: currentTime()
            }
            Repo.insert(
                Event.changeset(%Event{}, eventMap)
            )
            {:ok, eventMap}
        else
            {:error, "One or more fields are not present"}
        end
    end

    def getUserById(id) do
        Repo.get_by(User, id: id)
    end

    def getUserChangeset(%User{} = user) do
        User.changeset(user, %{})
    end

    # def authenticateAdminCredentials(emailId, plainTextPassword) do
    #     query = 
    #         from user in User, 
    #         where: user.email == ^emailId

    #     case Repo.one(query) do
    #         nil -> 
    #             Argon2.no_user_verify()
    #             {:error, :invalid_credentials}

    #         user -> 
    #             if Argon2.verify_pass(plainTextPassword, user.password) do
    #                 {:ok, user}
    #             else 
    #                 {:error, :invalid_credentials}
    #             end
    #     end
    # end

    def authenticateUser(emailId, plainTextPassword) do
        userQuery = 
            from user in User, 
            where: user.email == ^emailId
         
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

    defp getTopicIdByTopicName(topicName) do
        query =
            from topic in TopicOfInterest,
            where: topic.topicName == ^topicName,
            select:  topic.id

        Repo.one(query)
    end

    defp insertRecordInUserTopicTable(userId, topicId) do
        userTopicMap = %{
            userId: userId,
            topicId: topicId
        }

        Repo.insert(
            UserTopicsRelationship.changeset(
                %UserTopicsRelationship{},
                userTopicMap
            )
        )
    end

    def addNewTopicForCurrentUser(currentUser, params) do
        topicNameOrId = params["topic_name_or_id"]
        case Integer.parse(topicNameOrId) do
            :error -> 
                topicId =   
                    topicNameOrId
                    |> String.trim()
                    |> getTopicIdByTopicName()

                if is_nil(topicId) do
                    {:error, "Topic with given name does not exist"}
                else 
                    insertRecordInUserTopicTable(currentUser.id, topicId)
                    :ok
                end

            {parsedTopicId, _} -> 
                insertRecordInUserTopicTable(currentUser.id, parsedTopicId)
                :ok
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

    def deleteUserTopicAssociation(userId) do
        (
            from userTopicRelationship in UserTopicsRelationship,
            where: userTopicRelationship.userId == ^userId
        )
        |> Repo.delete_all()
    end

    def deleteUserByEmailId(emailId) do
        user = 
            (
                from user in User,
                where: user.email == ^emailId,
                select: user
            )
            |> Repo.one()

        deleteUserTopicAssociation(user.id)

        user
        |> Repo.delete()
    end

    def updateUserDetails(params) do
        query = 
            from user in User, 
            where: user.email == ^params["email"],
            select: user

        attrs = %{
            email: params["email"],
            password: params["password"],
            age: params["age"],
            fullName: params["fullName"],
            updated_at: currentTime()
        }
        
        try do 
            Repo.one(query)
            |> User.changeset(attrs)
            |> Repo.update()

            :ok
        catch 
            exception -> 
                {:error, exception}
        end
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
             userMap = 
             %{
                email: parameters["email"],
                password: parameters["password"],
                fullName: parameters["fullName"],
                age: validateType(parameters["age"]),
                inserted_at: currentTime(),
                updated_at: currentTime()
            }
            Repo.insert(
                User.changeset(%User{}, userMap)
            ) 
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

    def getEventsForCurrentUser(emailId) do
        userId = getUserIdByEmail(emailId)
        query = 
            from userEventRelationship in UserEventRelationship,
            left_join: event in Event, 
            on:  event.id == userEventRelationship.eventId,
            where: userEventRelationship.userId == ^userId,
            select: event

        allEvents = Repo.all(query)

        if allEvents == [] do
            {:error, "There are no events for this user"}
        else
            {:ok, allEvents}
        end
    end

    defp currentTime() do
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)
    end
end