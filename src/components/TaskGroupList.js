const TaskGroupList = ({ allTodos, setTaskGroupView }) => {
  const taskGroups = new Set(allTodos.map((t) => t["group"]));

  return (
    <div>
      <h1>Things To Do</h1>
      <ul>
        {Array.from(taskGroups).map((group) => {
          const groupedItems = allTodos.filter(
            (todo) => group === todo["group"]
          );
          return (
            <li key={group}>
              <TaskGroupItem
                setTaskGroupView={setTaskGroupView}
                group={group}
                items={groupedItems}
                key={group}
              />
            </li>
          );
        })}
      </ul>
    </div>
  );
};

const TaskGroupItem = ({ group, items, setTaskGroupView }) => {
  const totalCount = items.length;
  const completedCount = items.filter((i) => !!i["completedAt"]).length;

  return (
    <div className="group-item">
      <div>
        <img alt="Group of tasks" src="group.svg" width="10px" height="10px" />
      </div>

      <div>
        <h2 onClick={() => setTaskGroupView(group)}>{group}</h2>
        <span className="tasks-status">
          {completedCount} of {totalCount} tasks completed
        </span>
      </div>
    </div>
  );
};

export default TaskGroupList;
