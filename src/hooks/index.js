import { gql, useQuery } from "@apollo/client";

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

const useTodosQuery = () => {
  return useQuery(query);
};

export { useTodosQuery };
