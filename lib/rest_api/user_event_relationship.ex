defmodule RestApi.UserEventRelationship do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.Repo 

    @primary_key false
    schema "user_event_relationship" do
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
        |> cast(attrs, [:userId, :eventId, :isAccepted, :isRejected])
        |> validate_required([:userId, :eventId])
        |> foreign_key_constraint([:userId, :eventId])
    end
end