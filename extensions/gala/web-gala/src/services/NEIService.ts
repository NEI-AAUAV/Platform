import { createClient } from "./client";

const client = createClient("http://localhost/api/nei/v1");

const NEIService = {
  getUserById: async (id: string | number) => {
    const response: NEIUser = await client.get(`/user/${id}`);
    return response;
  },
};

export default NEIService;
