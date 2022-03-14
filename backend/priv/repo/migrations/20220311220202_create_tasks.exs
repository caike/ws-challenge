defmodule Backend.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :group_id, references(:groups)
      add :completed_at, :naive_datetime, default: nil

      timestamps()
    end
  end
end
