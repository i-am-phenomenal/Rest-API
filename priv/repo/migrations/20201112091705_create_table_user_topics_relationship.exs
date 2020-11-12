defmodule RestApi.Repo.Migrations.CreateTableUserTopicsRelationship do
  use Ecto.Migration

  def change do
    create table(:user_topics_relationship, primary_key: false) do
      add :id, :serial, primary_key: true
      add :userId, references(:users, type: :integer) 
      add :topicId, references(:topics_of_interests, type: :integer)
      
      timestamps()
    end
  end
end
