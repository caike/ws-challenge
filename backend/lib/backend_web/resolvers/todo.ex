defmodule BackendWeb.Resolvers.Todo do
  alias Backend.Todo

  @moduledoc """
  Resolver module for the Todo UI app
  """
  def all_tasks_resolver(_, _, _) do
    {:ok, Todo.list_all_tasks()}
  end
end
