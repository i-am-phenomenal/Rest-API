defmodule RestApi.Importer do
    import Ecto.Query, warn: false
    import Ecto

    alias RestApi.Repo 
    alias RestApi.User
    alias RestApi.TopicOfInterest
    alias RestApi.Event
    alias RestApi.UserEventRelationship
    alias RestApi.UserTopicsRelationship
    alias RestApi.TopicEventRelationship
    alias Argon2

    def seedData() do
        seedTopics()
        seedEvents()
        seedUser()
        seedUserEventRelationships()
        seedUserTopicRelationships()
        addMoreUserEventRelationships()
        addTopicEventRelationships()
    end

    defp addTopicEventRelationships() do
        (0..30)
        |> Enum.map(fn iter -> 
            topicEventRelationshipMap = 
                %{
                    topicId: Enum.random(1..10),
                    eventId: Enum.random(1..10)
                }
            
            TopicEventRelationship.changeset(%TopicEventRelationship{}, topicEventRelationshipMap)
            |> Repo.insert()
        end)
    end

    defp addMoreUserEventRelationships() do
        [
            %{
                eventId: 10,
                userId: 1,
                eventAcceptedOrRejected: "A"
            },
            %{
                eventId: 10,
                userId: 2,
                eventAcceptedOrRejected: "A"
            },
            %{
                eventId: 10,
                userId: 3,
                eventAcceptedOrRejected: "A"
            }
        ]
        |> Enum.map(fn userEventMap ->  
            Repo.insert(
                UserEventRelationship.changeset(%UserEventRelationship{}, userEventMap)
            )
        end)
    end

    defp seedUserTopicRelationships() do
        [
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 1,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 2,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 2,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 2,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 2,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 2,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 3,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 3,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 3,
                topicId: Enum.random(0..10),
            },
            %{
                userId: 3,
                topicId: Enum.random(0..10),
            }
        ]
        |> Enum.map(fn userTopicMap -> 
            case Repo.get_by(UserTopicsRelationship, userId: userTopicMap.userId, topicId: userTopicMap.topicId) do
                nil -> Repo.insert(
                    UserTopicsRelationship.changeset(%UserTopicsRelationship{}, userTopicMap)
                )
                _ -> 
                    nil
            end
        end)
    end

    defp seedUserEventRelationships() do
        choices = ["A", "R"]
        [
            %{
                userId: 3,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 3,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 1,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 1,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 2,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 2,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 2,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            },
            %{
                userId: 2,
                eventId: Enum.random(0..50),
                eventAcceptedOrRejected: Enum.random(choices)
            }   
        ]
        |> Enum.map(fn userEventMap -> 
            Repo.insert(
                UserEventRelationship.changeset(%UserEventRelationship{}, userEventMap)
            )
        end)
    end

    defp seedUser() do
        userMaps = [
            %{
                email: "chat29aditya@gmail.com",
                password: "pass",
                age: 30,
                fullName: "Aditya Chaturvedi"
            },
            %{
                email: "admin.email@gmail.com",
                password: "admin",
                age: 30,
                fullName: "Admin" 
            },
            %{
                email: "chat39email@gmail.com",
                password: "pass",
                age: 40,
                fullName: "Full Name"
            },

            %{
                email: "joeRogan@gmail.com",
                password: "pass",
                age: 40,
                fullName: "Joe Rogan"
            }
        ]
        |> Enum.map(fn userMap -> 
            Repo.insert(User.changeset(%User{}, userMap))    
        end)
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
            "Filmmaking",
            "Coding"
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