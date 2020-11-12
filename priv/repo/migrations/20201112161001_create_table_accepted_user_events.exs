defmodule RestApi.Repo.Migrations.CreateTableUserEventRelationship do
  use Ecto.Migration

  def change do
    create table(:user_event_relationships, primary_key: false) do
      add :id, :serial, primary_key: true
      add :userId, references(:users)
      add :eventId, references(:events)
      add :isAccepted, :boolean
      add :isRejected, :boolean

      timestamps()
    end
  end
end
