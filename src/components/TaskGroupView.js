import React, { useState } from "react";

const TaskGroupView = ({
  taskGroupView,
  clearTaskGroupView,
  filteredTodos,
}) => {
  return (
    <div>
      <div className="title">
        <h1>{taskGroupView}</h1>
        <div onClick={clearTaskGroupView}>
          <img alt="Task Group" src="group.svg" width="20px" height="20px" />
          <div>Back</div>
        </div>
      </div>

      <ul className="task-items">
        {filteredTodos.map((todo, i) => (
          <li key={todo["task"]}>
            <TaskDetails task={todo} />
          </li>
        ))}
      </ul>
    </div>
  );
};

const TaskDetails = ({ task }) => {
  const _isCompleted = !!task.completedAt;
  const [isCompleted, setIsCompleted] = useState(() => _isCompleted);

  return (
    <div
      className="is-clickable task-detail"
      onClick={() => setIsCompleted((v) => !v)}
    >
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

      <div className={isCompleted ? "is-completed" : ""}>{task["task"]}</div>
    </div>
  );
};

export default TaskGroupView;
