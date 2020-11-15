defmodule RestApi.Repo.Migrations.AddEventNameToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :eventName, :string, defaule: ""
    end
  end
end
