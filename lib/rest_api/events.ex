defmodule RestApi.Event do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.Repo

    @primary_key false
schema "events" do
    field :id, :integer, primary_key: true
        field :eventDescription, :binary
        field :eventType, :string
        field :eventDate, :utc_datetime
        field :eventDuration, :string
        field :eventHost, :string
        field :eventLocation, :string


        timestamps()
    end

    @doc false
    def changeset(event, attrs) do
        event
        |> cast(attrs, [:eventDescription, :eventType, :eventDate, :eventDuration, :eventHost, :eventLocation, :inserted_at, :updated_at])
        |> validate_required([:eventDescription, :eventLocation, :eventHost])
    end
end