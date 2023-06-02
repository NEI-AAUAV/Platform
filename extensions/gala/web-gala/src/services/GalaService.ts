import { createClient } from "./client";

const client = createClient("http://localhost/api/gala/v1");

const GalaService = {
  listTables: async () => {
    const response = await client.get<Table[]>("/table/list");
    return response;
  },
  getTable: async (id: string | number) => {
    const response = await client.get<Table>(`/table/${id}`);
    return response;
  },
  getSessionUser: async () => {
    const response = await client.get<User>("/user/me");
    return response;
  },

  listUsers: async () => {
    const response = await client.get<User[]>("/user/list");
    return response;
  },
};

export default GalaService;
