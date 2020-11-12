defmodule RestApi.Events do
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
end