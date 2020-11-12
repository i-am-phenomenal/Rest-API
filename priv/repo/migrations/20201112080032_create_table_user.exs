defmodule RestApi.Repo.Migrations.CreateTableUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :serial, primary_key: true
      add :email, :string
      add :fullName, :string 
      add :password, :string
      add :age, :integer
      timestamps()
    end
  end
end
