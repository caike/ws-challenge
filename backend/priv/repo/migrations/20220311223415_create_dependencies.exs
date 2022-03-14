defmodule Backend.Repo.Migrations.CreateDependencies do
  use Ecto.Migration

  def change do
    create table(:dependencies, primary_key: false) do
      add(:task_id, references(:tasks))
      add(:dependency_task_id, references(:tasks))

      timestamps()
    end

    create_if_not_exists(index(:dependencies, [:task_id]))
    create_if_not_exists(index(:dependencies, [:dependency_task_id]))

    create_if_not_exists(
      unique_index(
        :dependencies,
        [:task_id, :dependency_task_id]
      )
    )
  end
end
