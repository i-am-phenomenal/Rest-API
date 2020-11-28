defmodule RestApi.Repo.Migrations.CreateTableTopicEventRelationship do
  use Ecto.Migration

  def change do
      create table(:topic_event_relationships, primary_key: false) do
        add :id, :serial, primary_key: :true
        add :topicId, references(:topics_of_interests, type: :integer)
        add :eventId, references(:events, type: :integer)

        timestamps()
      end
  end
end
