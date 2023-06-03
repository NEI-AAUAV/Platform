import { createClient } from "./client";

const client = createClient("http://localhost/api/gala/v1");

const GalaService = {
  listTables: async () => {
    const response: Table[] = await client.get("/table/list");
    return response;
  },
  getTable: async (id: string | number) => {
    const response: Table = await client.get(`/table/${id}`);
    return response;
  },
  getSessionUser: async () => {
    const response: User = await client.get("/user/me");
    return response;
  },

  listUsers: async () => {
    const response: User[] = await client.get("/user/list");
    return response;
  },
};

export default GalaService;
