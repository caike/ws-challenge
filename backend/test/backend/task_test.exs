defmodule Backend.TaskTest do
  use Backend.DataCase

  alias Backend.Repo
  alias Backend.Todo
  alias Backend.Todo.Task

  setup do
    purchase_group = Todo.create_group!("Purchases")

    incomplete_task =
      Ecto.Changeset.change(%Task{}, %{
        group_id: purchase_group.id,
        name: "Go to the bank",
        dependencies: [],
        completed_at: nil
      })
      |> Repo.insert!()

    completed_task =
      Ecto.Changeset.change(%Task{}, %{
        group_id: purchase_group.id,
        name: "Go to the park",
        dependencies: [],
        completed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      })
      |> Repo.insert!()

    {:ok, completed_task: completed_task, incomplete_task: incomplete_task}
  end

  test "incomplete task toggles to completed", %{incomplete_task: task} do
    refute task.completed_at

    Todo.toggle_task!(task.id)

    task = Todo.get_task!(task.id)
    assert task.completed_at
  end

  test "completed task toggles to incomplete", %{completed_task: task} do
    assert task.completed_at

    Todo.toggle_task!(task.id)

    task = Todo.get_task!(task.id)
    refute task.completed_at
  end

  test "raises error for name and group duplicates", %{incomplete_task: task} do
    assert task.id

    new_task =
      Task.create_changeset(%Task{}, %{
        group_id: task.group_id,
        name: task.name
      })

    assert_raise Ecto.ConstraintError, fn ->
      Repo.insert!(new_task)
    end
  end
end
