defmodule BackendWeb.Schema do
  use Absinthe.Schema

  alias BackendWeb.Resolvers

  import_types(BackendWeb.Schema.TodoTypes)

  query do
    @desc "Get all todos"
    field :all_todos, non_null(list_of(non_null(:todo))) do
      resolve(&Resolvers.Todo.all_tasks_resolver/3)
    end
  end
end
