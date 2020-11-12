defmodule RestApi.TopicOfInterest do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.Repo 
    alias RestApi.User

    @primary_key false
    schema "topics_of_interests" do
        field :id, :integer, primary_key: true
        field :topicName, :string
        field :shortDesc, :binary

        many_to_many(
            :users,
            User,
            join_through: :users
        )
    end

    @doc false
    def changeset(topic, attributes) do
        topic
        |> cast(attributes, [:topicName, :shortDesc])
        |> validate_required(:topicName)
    end
end