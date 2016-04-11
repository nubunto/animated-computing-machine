defmodule Monitor.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :origin, :string
      add :data, :map

      timestamps
    end

  end
end
