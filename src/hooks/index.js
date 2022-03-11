import { gql, useQuery, useMutation } from "@apollo/client";

const query = gql`
  query {
    allTodos {
      id
      group
      name
      hasDependency
      completedAt
    }
  }
`;

const mutation = gql`
  mutation ToggleTodo($id: ID!) {
    toggleTodo(id: $id) {
      id
    }
  }
`;

const useTodosQuery = () => {
  return useQuery(query);
};

const useToggleTodoMutation = () => {
  return useMutation(mutation, { refetchQueries: [{ query }] });
};

export { useTodosQuery, useToggleTodoMutation };
