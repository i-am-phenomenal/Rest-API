defmodule RestApiWeb.AdminView do
    use RestApiWeb, :view

    def render("event.json", %{event: event}) do
        %{ 
            id: event.id,
            eventDescription: event.eventDescription,
            eventType: event.eventType, 
            eventDate: event.eventDate, 
            eventDuration: event.eventDuration,
            eventHost: event.eventHost,
            eventLocation: event.eventLocation,
            eventName: event.eventName,
            insertedAt: event.inserted_at,
            updated_at: event.updated_at
        }
    end

    def render("all_events.json", %{events: events}) do
        events
        |> Enum.map(fn event -> 
            %{ 
                id: event.id,
                eventDescription: event.eventDescription,
                eventType: event.eventType, 
                eventDate: event.eventDate, 
                eventDuration: event.eventDuration,
                eventName: event.eventName,
                eventHost: event.eventHost,
                eventLocation: event.eventLocation,
                insertedAt: event.inserted_at,
                updated_at: event.updated_at
            }
        end)
    end

    def render("topic.json", %{topic: topic}) do
        %{
            topicName: topic.topicName,
            shortDesc: topic.shortDesc
        }
    end

    def render("all_topics.json", %{topics: topics}) do
        topics
        |> Enum.map(fn topic -> 
            %{
                topicName: topic.topicName,
                shortDesc: topic.shortDesc
            }
        end)
    end
end