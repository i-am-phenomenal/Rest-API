defmodule RestApi.Event do
    use Ecto.Schema
    import Ecto.Changeset

    alias RestApi.TopicOfInterest

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
        field :eventName, :string

        # field :topic_of_interest_id, TopicOfInterest
        
        # belongs_to :topic_of_interest_id, TopicOfInterest, type: :string
        timestamps()
    end

    @doc false
    def changeset(event, attrs) do
        event
        |> cast(attrs, [:eventName, :eventDescription, :eventType, :eventDate, :eventDuration, :eventHost, :eventLocation, :inserted_at, :updated_at])
        |> validate_required([:eventName, :eventDescription, :eventLocation, :eventHost])
    end
end