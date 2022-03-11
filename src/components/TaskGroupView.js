const TaskGroupView = ({
  taskGroupView,
  clearTaskGroupView,
  filteredTodos,
}) => {
  return (
    <div>
      <div className="title">
        <h1>{taskGroupView}</h1>
        <div onClick={clearTaskGroupView}>All Groups</div>
      </div>

      <ul className="task-items">
        {filteredTodos.map((task, i) => (
          <li key={task["task"]}>
            <TaskDetails task={task} />
          </li>
        ))}
      </ul>
    </div>
  );
};

const TaskDetails = ({ task }) => {
  const isCompleted = !!task.completedAt;

  return (
    <>
      {isCompleted ? (
        <img
          alt="Completed task"
          src="completed.svg"
          width="20px"
          height="20px"
        />
      ) : (
        <img
          alt="Incomplete task"
          src="incomplete.svg"
          width="20px"
          height="20px"
        />
      )}

      <div>{task["task"]}</div>
    </>
  );
};

export default TaskGroupView;
