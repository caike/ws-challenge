defmodule Backend.Todo do
  alias Backend.Repo
  alias Backend.Todo.{Group, Task}

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
  end

  def list_all_tasks do
    query =
      from(t in Task,
        join: g in Group,
        on: g.id == t.group_id,
        select: %{
          id: t.id,
          group: g.name,
          task: t.name,
          dependencies: [],
          completed_at: t.completed_at
        }
      )

    Repo.all(query)
  end
end
