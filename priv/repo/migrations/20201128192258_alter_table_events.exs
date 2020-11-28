defmodule RestApi.Repo.Migrations.AlterTableEvents do
  use Ecto.Migration

  def change do
    alter table("events") do
      add :topic_of_interest_id, references(:topics_of_interests)
    end
  end
end
