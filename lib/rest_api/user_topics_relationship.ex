defmodule RestApi.UserTopicsRelationship do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.Repo

    @primary_key false
    schema "user_topics_relationship" do
        field :id, :integer
        field :userId, :integer
        #WIP
    end
end