import React from "react";

import "./App.css";

import TaskGroupList from "./components/TaskGroupList";
import TaskGroupView from "./components/TaskGroupView";
import { IconSad } from "./components/icons";

import { AppStateProvider, useAppState } from "./contexts";

const App = () => {
  return (
    <AppStateProvider>
      <TodoApp />
    </AppStateProvider>
  );
};

const TodoApp = () => {
  // taskGroupView is used as a simple way to navigate
  // between the two different pages.
  const { loading, error, taskGroupView } = useAppState();

  if (error) {
    return (
      <h1 className="wait-status">
        Something went wrong <IconSad />
      </h1>
    );
  }

  if (loading) {
    return <h1 className="wait-status">Loading...</h1>;
  }

  return (
    <div className="container">
      {taskGroupView ? <TaskGroupView /> : <TaskGroupList />}
    </div>
  );
};

export default App;
