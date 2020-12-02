defmodule RestApiWeb.AdminTopicEventView do
    use RestApiWeb, :view

    def render("all.json", %{topicEvents: topicEvents}) do
        Enum.map(topicEvents, fn topicEvent ->  
            topic = topicEvent.topic
            event = topicEvent.event
            %{
                topic: %{
                    topicName: topic.topicName,
                    shortDesc: topic.shortDesc
                },
                event: %{
                    eventName: event.eventName, 
                    eventDescription: event.eventDescription,
                    eventType: event.eventType,
                    eventDate: event.eventDate, 
                    eventDuration: event.eventDuration, 
                    eventHost: event.eventHost,
                    eventLocation: event.eventLocation
                }
            }
        end)
    end
end