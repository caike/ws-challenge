defmodule Backend.Repo.Migrations.AddUniquenessToTaskName do
  use Ecto.Migration

  def change do
    create_if_not_exists(
      unique_index(
        :tasks,
        [:name, :group_id]
      )
    )
  end
end
