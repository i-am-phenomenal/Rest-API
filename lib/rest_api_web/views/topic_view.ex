defmodule RestApiWeb.TopicView do
    use RestApiWeb, :view

    def render("user_topics.json", %{topics: topics}) do
        topics
        |> Enum.map(fn topic -> 
            %{
                topicId: topic.id,
                topicName: topic.topicName,
                shortDesc: topic.shortDesc
            }
        end)
    end
end