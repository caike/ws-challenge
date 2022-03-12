defmodule Backend.Todo do
  alias Backend.Repo
  alias Backend.Todo.{Group, Task, Dependency}

  import Ecto.Query

  def create_group!(name) do
    %Group{}
    |> Group.create_changeset(%{name: name})
    |> Repo.insert!()
  end

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

  def list_all_tasks do
    Task
    |> Repo.all()
  end
end
