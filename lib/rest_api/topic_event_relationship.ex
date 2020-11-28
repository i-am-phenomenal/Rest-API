defmodule RestApi.TopicEventRelationship do
    use Ecto.Schema 
    import Ecto.Changeset

    alias RestApi.Repo 

    @primary_key false
    schema "topic_event_relationships" do
        field :id, :integer, primary_key: true
        field :eventId, :integer
        field :topicId, :integer

        timestamps()
    end

    def changeset(topicEventRelationship, attrs) do
        topicEventRelationship
        |> cast(attrs, [:eventId, :topicId, :inserted_at, :updated_at])
        |> validate_required([:eventId, :topicId])
        |> foreign_key_constraint(:eventId)
        |> foreign_key_constraint(:topicId)
        |> unique_constraint([:topicId, :eventId])
    end
end