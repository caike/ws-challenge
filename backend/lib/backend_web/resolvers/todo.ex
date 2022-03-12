defmodule BackendWeb.Resolvers.Todo do
  @moduledoc """
  Resolver module for the Todo UI app
  with both resolvers and batch helper functions
  """

  alias Backend.Todo

  def all_tasks_resolver(_, _, _) do
    {:ok, Todo.list_all_tasks()}
  end

  def toggle_task_resolver(_, %{id: id}, _) do
    {:ok, Backend.Todo.toggle_task!(id)}
  end

  def groups_by_id(_, ids) do
    Todo.get_groups_by_ids(ids)
    |> Map.new(&{&1.id, &1})
  end

  def group_from_batch(group_id) do
    fn batch_results ->
      group = Map.get(batch_results, group_id)
      {:ok, group.name}
    end
  end

  def incomplete_dependencies_by_task_ids(_, task_ids) do
    Todo.get_incomplete_dependencies_by_task_ids(task_ids)
    |> Enum.reduce(%{}, fn dep, acc ->
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
