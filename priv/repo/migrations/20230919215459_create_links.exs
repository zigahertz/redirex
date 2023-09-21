defmodule Redirex.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :hash, :string, primary_key: true
      add :url, :string, null: false
      add :visits, :integer, default: 0

      timestamps()
    end

    create unique_index(:links, [:hash])
    create unique_index(:links, [:url])
  end
end
