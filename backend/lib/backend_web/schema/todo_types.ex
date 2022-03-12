defmodule BackendWeb.Schema.TodoTypes do
  use Absinthe.Schema.Notation

  alias BackendWeb.Resolvers

  object :todo do
    field(:id, non_null(:id))
    field(:name, :string, name: "task")
    field(:completed_at, :string)

    field(:group, non_null(:string)) do
      resolve(fn task, _, _ ->
        batch(
          {Resolvers.Todo, :groups_by_id},
          task.group_id,
          Resolvers.Todo.group_from_batch(task.group_id)
        )
      end)
    end

    field(:dependencies, non_null(list_of(:todo))) do
      resolve(fn task, _, _ ->
        batch(
          {Resolvers.Todo, :dependencies_by_task_ids},
          task.id,
          Resolvers.Todo.dependency_from_batch(task.id)
        )
      end)
    end
  end
end
