defmodule RestApi.Repo.Migrations.CreateTableAcceptedUserEvents do
  use Ecto.Migration

  def change do
    create table(:accepted_user_events, primary_key: false) do
      add :id, :serial, primary_key: true
      add :userId, :integer
      add :eventId, :integer
      add :isAccepted, :boolean
      add :isRejected, :boolean

      timestamps()
    end
  end
end
