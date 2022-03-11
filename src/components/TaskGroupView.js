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
          <img
            alt="Group of tasks"
            src="group.svg"
            width="20px"
            height="20px"
          />
          <div>Back</div>
        </div>
      </div>

      <ul className="task-items">
        {filteredTodos.map((task, i) => (
          <li key={task["group"] + task["name"]}>
            <TaskDetails task={task} />
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

      <div className={isCompleted ? "is-completed" : ""}>{task["name"]}</div>
    </div>
  );
};

export default TaskGroupView;
