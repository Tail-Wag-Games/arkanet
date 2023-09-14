defmodule Arkanet.Repo.Migrations.CreateLobbies do
  use Ecto.Migration

  def change do
    create table(:lobbies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      timestamps()
    end

    create unique_index(:lobbies, [:name])
  end
end
