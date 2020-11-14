defmodule RestApi.UserTopicsRelationship do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.Repo

    @primary_key false
    schema "user_topics_relationship" do
        field :id, :integer, primary_key: true
        field :userId, :integer
        field :topicId, :integer

        timestamps()
    end

    @doc false 
    def changeset(relationship, attrs) do
        relationship
        |> cast(attrs, [:userId, :topicId])
        |> unique_constraint([:userId, :topicId])
    end
end