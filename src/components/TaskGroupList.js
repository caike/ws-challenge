const TaskGroupList = ({ allTodos, setTaskGroupView }) => {
  const taskGroups = new Set(allTodos.map((t) => t["group"]));

  return (
    <div className="container">
      <h1>Things To Do</h1>
      {Array.from(taskGroups).map((group) => {
        const groupedItems = allTodos.filter((todo) => group === todo["group"]);
        return (
          <TaskGroupItem
            setTaskGroupView={setTaskGroupView}
            group={group}
            items={groupedItems}
            key={group}
          />
        );
      })}
    </div>
  );
};

const TaskGroupItem = ({ group, items, setTaskGroupView }) => {
  const totalCount = items.length;
  const completedCount = items.filter((i) => !!i["completedAt"]).length;

  return (
    <>
      <h2 onClick={() => setTaskGroupView(group)}>{group}</h2>
      <div>
        {completedCount} of {totalCount} tasks completed
      </div>
    </>
  );
};

export default TaskGroupList;
