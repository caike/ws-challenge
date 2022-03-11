defmodule BackendWeb.Schema do
  use Absinthe.Schema

  object :todo do
    field(:id, non_null(:id))
    field(:group, non_null(:string))
    field(:name, non_null(:string))
    field(:completed_at, :string)
  end

  query do
    @desc "Get all todos"
    field :all_todos, non_null(list_of(non_null(:todo))) do
      resolve(&all_tasks_resolver/3)
    end
  end

  defp all_tasks_resolver(_, _, _) do
    {:ok, Backend.Todo.list_all_tasks()}
  end
end
