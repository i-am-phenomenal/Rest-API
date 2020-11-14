defmodule RestApi.Repo.Migrations.CreateTableTopicsOfInterests do
  use Ecto.Migration

  def change do
    create table(:topics_of_interests, primary_key: false) do
      add :id, :serial, primary_key: true
      add :topicName, :string
      add :shortDesc, :binary, default: ""
      # add :type, references(:users, column: "id", type: :string)
    end
  end
end
