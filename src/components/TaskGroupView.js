import React, { useState } from "react";
import { useToggleTodoMutation } from "../hooks";

import { useAppState } from "../contexts";

const TaskGroupView = () => {
  const { taskGroupView, clearTaskGroupView, filteredTodos } = useAppState();
  const sortedFilteredTodos = filteredTodos.sort((t) => t["name"]);

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
        {sortedFilteredTodos.map((task, i) => (
          <li key={task["group"] + task["name"]}>
            <TaskDetails task={task} />
          </li>
        ))}
      </ul>
    </div>
  );
};

const TaskDetails = ({ task }) => {
  const hasDependency = !!task.hasDependency;

  if (hasDependency) {
    return <LockedTask task={task} />;
  } else {
    return <UnlockedTask task={task} />;
  }
};

const UnlockedTask = ({ task }) => {
  const _isCompleted = !!task.completedAt;
  const [isCompleted, setIsCompleted] = useState(() => _isCompleted);

  const [toggleTodo] = useToggleTodoMutation();

  const clickEvent = () => {
    setIsCompleted((v) => !v);
    toggleTodo({ variables: { id: task.id } });
  };

  return (
    <div className="is-clickable task-detail" onClick={clickEvent}>
      {isCompleted ? (
        <img
          alt="Completed Task"
          src="completed.svg"
          width="20px"
          height="20px"
        />
      ) : (
        <img
          alt="Incomplete Task"
          src="incomplete.svg"
          width="20px"
          height="20px"
        />
      )}

      <div className={isCompleted ? "is-completed" : ""}>{task["name"]}</div>
    </div>
  );
};

const LockedTask = ({ task }) => {
  return (
    <div className="is-locked task-detail">
      <img alt="Locked Task" src="locked.svg" width="20px" height="20px" />

      <div>{task["name"]}</div>
    </div>
  );
};

export default TaskGroupView;
