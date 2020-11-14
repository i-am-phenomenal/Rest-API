defmodule RestApi.User do
    use Ecto.Schema 
    import Ecto.Changeset

    alias RestApi.Repo 
    alias RestApi.TopicOfInterest
    alias Argon2 

    @primary_key false
    schema "users" do
        field :id, :integer, primary_key: true
        field :email, :string
        field :fullName, :string
        field :password, :string
        field :age, :integer

        # many_to_many(
        #     :topics_of_interests,
        #     TopicOfInterest,
        #     join_through: :topics_of_interests
        # )
        # has_many :topics_of_interests, TopicOfInterest, references: :id
        timestamps()
    end

    @doc false
    def changeset(user, attributes) do
        user
        |> cast(attributes, [:email, :fullName, :password, :age])
        |> validate_required(:email, :password)
        |> putPasswordHash()
    end

    defp putPasswordHash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
        change(changeset, password: Argon2.hash_pwd_salt(password))
    end 

    defp putPasswordHash(changeset), do: changeset
end