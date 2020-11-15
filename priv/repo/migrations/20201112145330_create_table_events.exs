defmodule RestApi.Repo.Migrations.CreateTableEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :serial, primary_key: true
      add :eventDescription, :binary, default: ""
      add :eventType, :string
      add :eventDate, :utc_datetime
      add :eventDuration, :string
      add :eventHost, :string
      add :eventLocation, :string

      timestamps()
    end
  end
end
