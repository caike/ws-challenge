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

    timestamps()
  end

  def create_changeset(task, attrs) do
    task
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
