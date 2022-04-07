import React, { useState, createContext, useContext } from "react";
import { useTodosQuery } from "./../hooks";

const TodoContext = createContext();

export function useAppState() {
  return useContext(TodoContext);
}

export function AppStateProvider({ children }) {
  const { data, loading, error } = useTodosQuery();

  const [taskGroupView, setTaskGroupView] = useState(null);
  const [allTodos, setAllTodos] = useState([]);
  const [filteredTodos, setFilteredTodos] = useState([]);

  React.useEffect(() => {
    if (data) {
      const _allTodos = data.allTodos;
      setAllTodos(_allTodos);
    }
  }, [setAllTodos, data]);

  React.useEffect(() => {
    if (taskGroupView) {
      const _filtered = allTodos.filter((t) => t["group"] === taskGroupView);
      setFilteredTodos(_filtered);
    }
  }, [setFilteredTodos, allTodos, taskGroupView]);

  const clearTaskGroupView = () => setTaskGroupView(null);

  return (
    <TodoContext.Provider
      value={{
        loading,
        error,
        allTodos,
        filteredTodos,
        taskGroupView,
        setTaskGroupView,
        clearTaskGroupView,
      }}
    >
      {children}
    </TodoContext.Provider>
  );
}
