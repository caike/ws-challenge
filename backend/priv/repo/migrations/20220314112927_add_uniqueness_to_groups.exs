defmodule Backend.Repo.Migrations.AddUniquenessToGroups do
  use Ecto.Migration

  def change do
    create_if_not_exists(
      unique_index(
        :groups,
        [:name]
      )
    )
  end
end
