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
  the group to which it belongs to and the tasks it depends on
  """
  @spec create_task!(map()) :: Task.t()
  def create_task!(attrs) do
    %Task{}
    |> Task.create_changeset(attrs)
    |> Repo.insert!()
    |> add_dependencies!(attrs)
  end

  defp add_dependencies!(task, %{dependencies: deps}) when length(deps) > 0 do
    dependencies = Enum.map(deps, &Repo.get_by(Task, name: &1.name))

    task
    |> Repo.preload(:dependencies)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:dependencies, dependencies)
    |> Repo.update!()
  end

  defp add_dependencies!(task, _), do: task

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
        left_join: d in assoc(t, :dependencies),
        group_by: [t.id, g.id],
        select: %{
          id: t.id,
          name: t.name,
          group: g.name,
          completed_at: t.completed_at,
          has_dependency: count(d.id) > 0
        }
      )

    Repo.all(query)
  end

  def toggle_task!(id) do
    task =
      get_task!(id)
      |> Repo.preload(:dependencies)

    # Raise error if any of the dependencies
    # have not been completed
    for dep <- task.dependencies,
        is_nil(dep.completed_at),
        do: raise("Must complete dependency first")

    # Reset completed_dependents when
    # dependency is marked as incomplete
    task =
      task
      |> Repo.preload(:completed_dependents)

    Backend.Repo.transaction(fn ->
      for dependent <- task.completed_dependents,
          do: dependent |> Task.create_toggle_changeset() |> Repo.update!()

      task
      |> Task.create_toggle_changeset()
      |> Repo.update!()
    end)

    # Must return task for Asbinthe
    task
  end

  def get_task!(id), do: Repo.get!(Task, id)
end
