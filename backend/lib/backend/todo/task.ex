defmodule Backend.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_params [
    :name,
    :group_id
  ]

  @required_params [
    :name,
    :group_id
  ]

  @type t :: %__MODULE__{}

  schema "tasks" do
    field(:name, :string)
    field(:completed_at, :naive_datetime)

    belongs_to(:group, Backend.Todo.Group)

    many_to_many(
      :dependencies,
      __MODULE__,
      join_through: Backend.Todo.Dependency,
      join_keys: [task_id: :id, dependency_task_id: :id]
    )

    timestamps()
  end

  def create_changeset(task, attrs) do
    task
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end

  def create_toggle_changeset(task) do
    case task.completed_at do
      nil ->
        time_now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        task |> Ecto.Changeset.change(%{completed_at: time_now})

      _ ->
        task |> Ecto.Changeset.change(%{completed_at: nil})
    end
  end
end
