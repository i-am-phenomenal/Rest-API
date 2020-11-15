defmodule RestApiWeb.AdminView do
    use RestApiWeb, :view

    def render("event.json", %{event: event}) do
        event
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
                eventHost: event.eventHost,
                eventLocation: event.eventLocation,
                insertedAt: event.inserted_at,
                updated_at: event.updated_at
            }
        end)
    end
end