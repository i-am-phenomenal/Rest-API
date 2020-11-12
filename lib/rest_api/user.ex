defmodule RestApi.User do
    use Ecto.Schema 
    import Ecto.Changeset

    alias RestApi.Repo 
    alias RestApi.TopicOfInterest

    @primary_key false
    schema "users" do
        field :id, :integer, primary_key: true
        field :email, :string
        field :fullName, :string
        field :password, :string
        field :age, :integer

        many_to_many(
            :topics_of_interests,
            TopicOfInterest,
            join_through: :topics_of_interests
        )
        timestamps()
    end

    @doc false
    def changeset(user, attributes) do
        user
        |> cast(attributes, [:email, :fullName, :password, :age])
        |> validate_required(:email, :password)
    end
end