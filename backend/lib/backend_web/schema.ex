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

  mutation do
    @desc "Toggle todo"
    field :toggle_todo, :id do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Todo.toggle_task_resolver/3)
    end
  end
end
