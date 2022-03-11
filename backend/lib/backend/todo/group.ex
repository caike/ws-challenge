defmodule Backend.Todo.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_params [
    :name
  ]

  @required_params [
    :name
  ]

  schema "groups" do
    field :name, :string

    timestamps()
  end

  def create_changeset(group, attrs) do
    group
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
