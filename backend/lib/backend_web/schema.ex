defmodule BackendWeb.Schema do
  use Absinthe.Schema

  object :todo do
    field(:id, non_null(:id))
    field(:group, non_null(:string))
    field(:name, non_null(:string))
    field(:has_dependency, non_null(:boolean))
    field(:completed_at, :string)
  end

  query do
    @desc "Get all todos"
    field :all_todos, non_null(list_of(non_null(:todo))) do
      resolve(&all_tasks_resolver/3)
    end
  end

  mutation do
    @desc "Toggle todo"
    field :toggle_todo, non_null(:todo) do
      arg(:id, non_null(:id))
      resolve(&toggle_todo/3)
    end
  end

  defp all_tasks_resolver(_, _, _) do
    {:ok, Backend.Todo.list_all_tasks()}
  end

  defp toggle_todo(_, %{id: id}, _) do
    {:ok, Backend.Todo.toggle_task!(id)}
  end
end
