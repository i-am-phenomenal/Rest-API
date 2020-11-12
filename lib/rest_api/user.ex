defmodule RestApi.User do
    use Ecto.Schema 
    import Ecto.Changeset

    alias RestApi.Repo 

    @primary_key false
    schema "users" do
        field :id, :integer, primary_key: true
        field :email, :string
        field :fullName, :string
        field :password, :string
        field :age, :integer

        timestamps()
    end

    @doc false
    def changeset(user, attributes) do
        user
        |> cast(attributes, [:email, :fullName, :password, :age])
        |> validate_required(:email, :password)
    end
end