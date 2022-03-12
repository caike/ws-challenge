defmodule Backend.Todo do
  alias Backend.Repo
  alias Backend.Todo.{Group, Task, Dependency}

  import Ecto.Query

  @spec create_group!(String.t()) :: Group.t()
  def create_group!(name) do
    %Group{}
    |> Group.create_changeset(%{name: name})
    |> Repo.insert!()
  end

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

  @spec list_all_tasks() :: [Task.t()]
  def list_all_tasks do
    Task
    |> Repo.all()
  end

  @spec toggle_task!(integer()) :: Task.t()
  def toggle_task!(id) do
    get_task!(id)
    |> Task.create_toggle_changeset()
    |> Repo.update!()
  end

  @spec get_task!(integer()) :: Task.t()
  def get_task!(id), do: Repo.get!(Task, id)

  @spec get_groups_by_ids([integer()]) :: [Group.t()]
  def get_groups_by_ids(group_ids) do
    group_ids = group_ids |> Enum.uniq()

    Group
    |> where([m], m.id in ^group_ids)
    |> Backend.Repo.all()
  end

  @doc """
  Returns incomplete dependencies for a list of task ids
  """
  @spec get_incomplete_dependencies_by_task_ids([integer()]) ::
          [Dependency.t()] | []
  def get_incomplete_dependencies_by_task_ids(task_ids) do
    task_ids = task_ids |> Enum.uniq()

    from(
      d in Dependency,
      join: dt in assoc(d, :dependency_task),
      where: d.task_id in ^task_ids and is_nil(dt.completed_at)
    )
    |> Repo.all()
    |> Repo.preload(:dependency_task)
  end
end
