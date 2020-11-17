defmodule RestApiWeb.UserView do
    use RestApiWeb, :view

    def render("user_sign_up.json", %{resp: resp}) do
        resp
        |> Map.from_struct()
        |> Map.drop([:__meta__, :topics_of_interests])
    end

    def render("user.json", %{user: user}) do
        %{
            userId: user.id,
            fullName: user.fullName, 
            age: user.age,
            email: user.email,
            password: user.password
        }
    end

    def render("all_events.json", %{allEvents: allEvents, emailId: emailId}) do
        formattedEvents = 
            allEvents
            |> Enum.map(fn event -> 
                %{
                    eventName:  event.eventName,
                    eventType: event.eventType,
                    eventDescription: event.eventDescription,
                    eventDate: event.eventDate,
                    eventDuration: event.eventDuration,
                    eventHost: event.eventHost,
                    eventLocation: event.eventLocation
                }
            end)

        %{
            events: formattedEvents,
            emailId: emailId
        }
    end

    def render("user_topic_of_interest.json", %{resp: relationship}) do
        %{
            userId: relationship.userId,
            topicId: relationship.topicId   
        }
    end

    def render("all_user_records.json", %{userRecords: userRecords}) do
        userRecords
        |> Enum.map(fn record -> 
            %{
                fullName: record.fullName,
                email: record.email,
                age: record.age,
                id: record.id,
                password: record.password,
                topicsOfInterest: getTopicsOfInterest(record.topics)
            }
        end)
    end

    def getTopicsOfInterest(topics) do
        topics
        |> Enum.map(fn topic -> 
            %{
                topicName: topic.topicName,
                shortDesc: topic.shortDesc
            }
        end)
    end
  end
  
