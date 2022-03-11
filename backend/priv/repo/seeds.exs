alias Backend.Todo

Backend.Repo.transaction(fn ->
  purchase_group = Todo.create_group!("Purchases")
  airplane_group = Todo.create_group!("Build Airplane")

  bank = %{
    group_id: purchase_group.id,
    name: "Go to the bank",
    dependencies: [],
    completed_at: nil
  }

  hammer = %{
    group_id: purchase_group.id,
    name: "Buy hammer",
    dependencies: [
      bank
    ],
    completed_at: nil
  }

  wood = %{
    group_id: purchase_group.id,
    name: "Buy wood",
    dependencies: [
      bank
    ],
    completed_at: nil
  }

  nails = %{
    group_id: purchase_group.id,
    name: "Buy nails",
    dependencies: [
      bank
    ],
    completed_at: nil
  }

  paint = %{
    group_id: purchase_group.id,
    name: "Buy paint",
    dependencies: [
      bank
    ],
    completed_at: nil
  }

  fasten = %{
    group_id: airplane_group.id,
    name: "Hammer nails into wood",
    dependencies: [
      hammer,
      wood,
      nails
    ],
    completed_at: nil
  }

  wings = %{
    group_id: airplane_group.id,
    name: "Paint wings",
    dependencies: [
      paint,
      fasten
    ],
    completed_at: nil
  }

  snack = %{
    group_id: airplane_group.id,
    name: "Have a snack",
    dependencies: [],
    completed_at: nil
  }

  for task <- [bank, hammer, wood, nails, paint, fasten, wings, snack],
      do: Todo.create_task!(task)
end)
