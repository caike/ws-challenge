import React from "react";
import { useAppState } from "./../contexts";
import { IconAlert, IconCheck } from "./icons";

const TaskGroupList = () => {
  const { allTodos } = useAppState();
  // using Set here to automatically remove dups
  const taskGroups = new Set(allTodos.map((t) => t["group"]));
  const sortedTaskGroups = Array.from(taskGroups).sort((a, b) =>
    b.localeCompare(a)
  );

  return (
    <div>
      <h1>Things To Do</h1>
      <ul>
        {sortedTaskGroups.map((group) => {
          const groupedItems = allTodos.filter(
            (todo) => group === todo["group"]
          );
          return (
            <li className="is-clickable" key={group}>
              <TaskGroupItem group={group} items={groupedItems} />
            </li>
          );
        })}
      </ul>
    </div>
  );
};

const TaskGroupItem = ({ group, items }) => {
  const { setTaskGroupView } = useAppState();

  const totalCount = items.length;
  const completedCount = items.filter((i) => !!i["completedAt"]).length;

  const isCompleted = completedCount === totalCount;
  const taskGroupIcon = isCompleted ? <IconCheck /> : <IconAlert />;

  return (
    <div className="group-item">
      <div>
        <img alt="Group of tasks" src="group.svg" width="10px" height="10px" />
      </div>

      <div>
        <h2 onClick={() => setTaskGroupView(group)}>{group}</h2>
        <span className="tasks-status">
          {completedCount} of {totalCount} tasks completed {taskGroupIcon}
        </span>
      </div>
    </div>
  );
};

export default TaskGroupList;
