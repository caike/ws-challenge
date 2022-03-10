const TaskGroupView = ({
  taskGroupView,
  clearTaskGroupView,
  filteredTodos,
}) => {
  return (
    <>
      <h1>{taskGroupView}</h1>

      <div onClick={clearTaskGroupView}>All Groups</div>

      {filteredTodos.map((t, i) => (
        <div key={i}>{t["task"]}</div>
      ))}
    </>
  );
};

export default TaskGroupView;
