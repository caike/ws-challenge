defmodule Backend.Todo.Dependency do
  @moduledoc """
  Join-schema to map dependencies for a given task
  """
  use Ecto.Schema
  alias Backend.Todo.Task

  @type t :: %__MODULE__{}

  @primary_key false
  schema "dependencies" do
    belongs_to(:task, Task)
    belongs_to(:dependency_task, Task)

    timestamps()
  end
end
