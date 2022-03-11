defmodule Backend.Todo do
  @moduledoc """
  Context module to interact with the Todo list,
  including operations with Group and Task
  """
  alias Backend.Repo
  alias Backend.Todo.{Group, Task}
  import Ecto.Query

  @doc """
  Creates a Group by name
  """
  @spec create_group!(String.t()) :: Group.t()
  def create_group!(name) do
    %Group{}
    |> Group.create_changeset(%{name: name})
    |> Repo.insert!()
  end

  @doc """
  Creates a Task by its attributes, including
  the group to which it belongs to
  """
  @spec create_task!(map()) :: Task.t()
  def create_task!(attrs) do
    %Task{}
    |> Task.create_changeset(attrs)
    |> Repo.insert!()
  end

  @type resolver_task :: %Task{
          id: integer(),
          name: String.t(),
          group: String.t(),
          completed_at: NaiveDateTime.t() | nil
        }

  @doc """
  Lists all tasks. Used by the GQL resolver
  """
  @spec list_all_tasks() :: [resolver_task()]
  def list_all_tasks do
    query =
      from(t in Task,
        join: g in Group,
        on: g.id == t.group_id,
        select: %{
          id: t.id,
          name: t.name,
          group: g.name,
          completed_at: t.completed_at
        }
      )

    Repo.all(query)
  end
end
