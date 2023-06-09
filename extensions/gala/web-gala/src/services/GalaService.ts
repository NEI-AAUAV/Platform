import config from "@/config";
import { createClient } from "./client";

const client = createClient(`${config.BASE_URL}/api/gala/v1`);

type ReserveTable = {
  dish: string;
  allergies: string;
  companions: {
    dish: string;
    allergies: string;
  }[];
};

type Confirmation = {
  uid: number;
  confirm: boolean;
};

type EditUser = {
  id: number;
  matriculation: number | null;
  nmec: number | null;
  email: string;
  name: string;
  has_payed: boolean;
};

type CreateUser = {
  email: string;
  matriculation: number | null;
};

const GalaService = {
  table: {
    listTables: async () => {
      const response: Table[] = await client.get("/table/list");
      return response;
    },
    getTable: async (id: string | number) => {
      const response: Table = await client.get(`/table/${id}`);
      return response;
    },
    createTable: async (request: { seats: number }) => {
      const response: Table = await client.post("/table/new", request);
      return response;
    },
    editTable: async (id: string | number, request: { name: string }) => {
      const response: Table = await client.put(`/table/${id}/edit`, request);
      return response;
    },
    reserveTable: async (id: string | number, request: ReserveTable) => {
      const response: Table = await client.post(
        `/table/${id}/reserve`,
        request,
      );
      return response;
    },
    confirmTable: async (id: string | number, request: Confirmation) => {
      const response: Table = await client.patch(
        `/table/${id}/confirm`,
        request,
      );
      return response;
    },
    tableTransfer: async (id: string | number, request: { uid: number }) => {
      const response: Table = await client.patch(
        `/table/${id}/transfer`,
        request,
      );
      return response;
    },
    tableLeave: async (id: string | number) => {
      const response: Table = await client.delete(`/table/${id}/leave`);
      return response;
    },
    tableRemoveUser: async (id: string | number, uid: string | number) => {
      const response: Table = await client.delete(`/table/${id}/remove/${uid}`);
      return response;
    },
  },
  user: {
    listUsers: async () => {
      const response: User[] = await client.get("/users/list");
      return response;
    },
    editUser: async (request: EditUser) => {
      const response: User = await client.put(`/users`, request);
      return response;
    },
    createUser: async (request: CreateUser) => {
      const response: User = await client.post(`/users`, request);
      return response;
    },
    getSessionUser: async () => {
      const response: User = await client.get("/users/me");
      return response;
    },
  },
};

export default GalaService;
