defmodule BackendWeb.Resolvers.Todo do
  @moduledoc """
  Resolver module for the Todo UI app
  with both resolver and helper functions
  """

  alias Backend.{Todo, Repo}
  alias Backend.Todo.{Dependency, Group}
  import Ecto.Query

  def all_tasks_resolver(_, _, _) do
    {:ok, Todo.list_all_tasks()}
  end

  def groups_by_id(_, ids) do
    ids = ids |> Enum.uniq()

    Todo.Group
    |> where([m], m.id in ^ids)
    |> Backend.Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def group_from_batch(group_id) do
    fn batch_results ->
      group = Map.get(batch_results, group_id)
      {:ok, group.name}
    end
  end

  def dependencies_by_task_ids(_, task_ids) do
    dependencies =
      from(
        d in Todo.Dependency,
        where: d.task_id in ^task_ids
      )
      |> Repo.all()
      |> Repo.preload(:dependency_task)

    Enum.reduce(dependencies, %{}, fn dep, acc ->
      current_value = Map.get(acc, dep.task_id, [])
      Map.put(acc, dep.task_id, current_value ++ [dep])
    end)
  end

  def dependency_from_batch(task_id) do
    fn batch_results ->
      case Map.get(batch_results, task_id) do
        nil -> {:ok, []}
        deps -> {:ok, Enum.map(deps, & &1.dependency_task)}
      end
    end
  end
end
