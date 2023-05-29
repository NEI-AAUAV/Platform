import { createClient } from "./client";

const client = createClient("http://localhost/api/gala/v1");

class GalaService {
  async listTables() {
    return await client.get("/table/list");
  }

  async getTable(id: string | number) {
    return await client.get(`/table/${id}`);
  }
}

export default new GalaService();
