defmodule Monitor.Repo.Migrations.CreateApplication do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :name, :string
      add :app_id, :string

      timestamps
    end

  end
end
