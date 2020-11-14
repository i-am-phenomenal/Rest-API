defmodule RestApi.Repo.Migrations.AlterTableTopicsOfInterests do
  use Ecto.Migration

  def change do
    alter table("topics_of_interests") do
      add :user_id, :integer
    end
  end
end
