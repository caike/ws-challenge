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

    dependent_task =
      Ecto.Changeset.change(%Task{}, %{
        group_id: purchase_group.id,
        name: "Buy hammer",
        dependencies: [
          incomplete_task
        ],
        completed_at: nil
      })
      |> Repo.insert!()

    {:ok,
     completed_task: completed_task,
     incomplete_task: incomplete_task,
     dependent_task: dependent_task}
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

  test "incomplete task with dependency raises error when toggle",
       %{dependent_task: task} do
    assert length(task.dependencies) == 1
    [dep | _] = task.dependencies

    refute dep.completed_at
    refute task.completed_at

    assert_raise RuntimeError, fn ->
      Todo.toggle_task!(task.id)
    end

    refute task.completed_at
  end

  test "completed task with dependents toggles to incomplete and resets dependents", %{
    incomplete_task: task1,
    dependent_task: task2
  } do
    refute task1.completed_at
    refute task2.completed_at

    # Just to be sure that task2 depends
    # on task1 being complete first
    assert_raise RuntimeError, fn ->
      Todo.toggle_task!(task2.id)
    end

    # Completes both
    Todo.toggle_task!(task1.id)
    Todo.toggle_task!(task2.id)

    task1 = Todo.get_task!(task1.id)
    task2 = Todo.get_task!(task2.id)

    assert task1.completed_at
    assert task2.completed_at

    # Mark dependency as incomplete
    Todo.toggle_task!(task1.id)

    task1 = Todo.get_task!(task1.id)
    refute task1.completed_at

    task2 = Todo.get_task!(task2.id)
    refute task2.completed_at
  end
end
