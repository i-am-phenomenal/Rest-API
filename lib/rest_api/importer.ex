defmodule RestApi.Importer do
    import Ecto.Query, warn: false
    import Ecto

    alias RestApi.Repo 
    alias RestApi.User
    alias RestApi.TopicOfInterest
    alias RestApi.Event
    alias Argon2

    def seedData() do
        seedTopics()
        seedEvents()
        seedUser()
    end

    defp seedUser() do
        userMap = %{
            email: "chat29aditya@gmail.com",
            password: "pass",
            age: 30,
            fullName: "Aditya Chaturvedi"
        }
        
        Repo.insert(User.changeset(%User{}, userMap))
    end

    defp seedEvents() do
        (0..50)
        |> Enum.map(fn iter -> 
            str = to_string(iter)
            eventMap =%{
                eventDescription: "Description " <> str,
                eventType: "Event Type " <> str,
                eventName: "Event Name " <> str,
                eventDate: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
                eventDuration: "Event Duration " <> str,
                eventHost: "Event Host " <> str,
                eventLocation: "Event Location " <> str,
                inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
                updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
            }
            Repo.insert(
                Event.changeset(%Event{}, eventMap)
            )
        end)
    end

    defp seedTopics() do
        [
            "Sports",
            "Cars",
            "Reading",
            "Gaming",
            "Photography",
            "Music",
            "Travelling",
            "Fitness",
            "Healthcare",
            "Gardening",
            "Social work",
            "Humor",
            "Journaling",
            "Juggling",
            "Candy Making",
            "Cleaning",
            "Sewing",
            "Skeying",
            "Acting",
            "Filmmaking"
        ]
        |> Enum.map(fn topicName -> 
            changeset = TopicOfInterest.changeset(%TopicOfInterest{}, %{
                topicName: topicName,
                shortDesc: ""
            })
            Repo.insert(changeset)
        end)
    end
end