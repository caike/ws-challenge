defmodule Backend.Todo.Dependency do
  use Ecto.Schema
  alias Backend.Todo.Task

  @primary_key false
  schema "dependencies" do
    belongs_to(:task, Task)
    belongs_to(:dependency_task, Task)

    timestamps()
  end
end
