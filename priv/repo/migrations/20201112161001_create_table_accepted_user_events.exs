defmodule RestApi.Repo.Migrations.CreateTableUserEventRelationship do
  use Ecto.Migration

  def change do
    create table(:user_event_relationships, primary_key: false) do
      add :id, :serial, primary_key: true
      add :userId, references(:users, type: :integer)
      add :eventId, references(:events, type: :integer)
      add :eventAcceptedOrRejected, :string
  
      timestamps()
    end
  end
end
