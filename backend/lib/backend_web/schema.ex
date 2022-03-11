defmodule BackendWeb.Schema do
  use Absinthe.Schema

  alias BackendWeb.Resolvers.Todo

  object :todo do
    field(:id, non_null(:id))
    field(:group, non_null(:string))
    field(:task, non_null(:string))
    field(:dependencies, non_null(list_of(:todo)))
    field(:completed_at, :string)
  end

  query do
    @desc "Get all todos"
    field :all_todos, non_null(list_of(non_null(:todo))) do
      resolve(&Todo.all_tasks_resolver/3)
    end
  end
end
