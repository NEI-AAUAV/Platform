import { createClient } from "./client";

const client = createClient("http://localhost/api/gala/v1");

class GalaService {
  async listTables() {
    const response = await client.get<Table[]>("/table/list");
    return response;
  }

  async getTable(id: string | number) {
    const response = await client.get<Table>(`/table/${id}`);
    return response;
  }

  async getUserSelf() {
    const response = await client.get<User>("/user/self");
    return response;
  }
}

export default new GalaService();
