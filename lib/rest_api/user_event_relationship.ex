defmodule RestApi.UserEventRelationship do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.Repo 

    @primary_key false
    schema "user_event_relationships" do
        field :id, :integer, primary_key: true
        field :userId, :integer
        field :eventId, :integer
        # Possible states are
        # "A" -> Accepted
        # "R" -> Rejected
        field :eventAcceptedOrRejected, :string
        
        timestamps()
    end

    @doc false
    def changeset(relationship, attrs) do
        relationship
        |> cast(attrs, [:userId, :eventId, :eventAcceptedOrRejected, :inserted_at, :updated_at])
        |> validate_required([:userId, :eventId])
        |> foreign_key_constraint(:userId)
        |> foreign_key_constraint(:eventId)
        |> unique_constraint([:userId, :eventId])
        |> validate_inclusion(:eventAcceptedOrRejected, ["A", "R"])
    end
end