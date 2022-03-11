import { gql, useQuery } from "@apollo/client";

const query = gql`
  query {
    allTodos {
      id
      group
      name
      completedAt
    }
  }
`;

const useTodosQuery = () => {
  return useQuery(query);
};

export { useTodosQuery };
