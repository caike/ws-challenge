import React, { useState } from "react";

import "./App.css";

import { useTodosQuery } from "./hooks";

import TaskGroupView from "./components/TaskGroupView";
import TaskGroupList from "./components/TaskGroupList";

const App = () => {
  const { data, loading } = useTodosQuery();
  const [taskGroupView, setTaskGroupView] = useState(null);

  if (loading) {
    return <h1>Loading...</h1>;
  }

  const allTodos = (data && data.allTodos) || [];
  let filteredTodos;

  if (taskGroupView) {
    filteredTodos = allTodos.filter((t) => t["group"] === taskGroupView);
  }

  const clearTaskGroupView = () => setTaskGroupView(null);

  return (
    <div className="container">
      {taskGroupView ? (
        <TaskGroupView
          taskGroupView={taskGroupView}
          filteredTodos={filteredTodos}
          clearTaskGroupView={clearTaskGroupView}
        />
      ) : (
        <TaskGroupList
          allTodos={allTodos}
          setTaskGroupView={setTaskGroupView}
        />
      )}
    </div>
  );
};

export default App;
