import React, { useState } from "react";
import { useToggleTodoMutation } from "../hooks";

import { useAppState } from "../contexts";

const TaskGroupView = () => {
  const { taskGroupView, clearTaskGroupView, filteredTodos } = useAppState();
  const sortedTodos = filteredTodos.sort((a, b) =>
    a["task"].localeCompare(b["task"])
  );

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
        {sortedTodos.map((todo, i) => (
          <li key={todo["task"]}>
            <TaskDetails task={todo} />
          </li>
        ))}
      </ul>
    </div>
  );
};

const TaskDetails = ({ task }) => {
  const hasDependency = (task.dependencies || []).length > 0;

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

const LockedTask = ({ task }) => {
  return (
    <div className="task-detail">
      <img alt="Locked task" src="locked.svg" width="20px" height="20px" />

      <div>{task["task"]}</div>
    </div>
  );
};

export default TaskGroupView;
