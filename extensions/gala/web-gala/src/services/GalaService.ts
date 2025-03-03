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
  has_payed: boolean;
};

type CreateUser = {
  nmec: number | null;
  matriculation: number | null;
};

type EditTimeSlots = {
  votesStart?: string;
  votesEnd?: string;
  tablesStart?: string;
  tablesEnd?: string;
};

export type Limits = {
  maxRegistrations: number;
};

export type EditLimits = Partial<Limits>;

type VoteCategoryCreate = {
  category: string;
  options: string[];
};

export type VoteCategoryEdit = Partial<VoteCategoryCreate>;

type VoteCategoryCast = {
  option: number;
};

const GalaService = {
  table: {
    listTables: async () => {
      const response: Table[] = await client.get("/table/list");
      return response;
    },
    listTablesPublic: async () => {
      const response: Table[] = await client.get("/table/list/public");
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
      const response: User[] = await client.get("/users");
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
  time: {
    getTimeSlots: async () => {
      const response: TimeSlots = await client.get(`/slots`);
      return response;
    },
    editTimeSlots: async (request: EditTimeSlots) => {
      const response: TimeSlots = await client.put(`/slots`, request);
      return response;
    },
  },
  limits: {
    getLimits: async () => {
      const response: Limits = await client.get(`/limits`);
      return response;
    },
    editTimeSlots: async (request: EditLimits) => {
      const response: Limits = await client.put(`/limits`, request);
      return response;
    },
  },
  vote: {
    listCategories: async () => {
      const response: Vote[] = await client.get("/votes/list");
      return response;
    },
    getCategory: async (id: string | number) => {
      const response: Vote = await client.get(`/votes/${id}`);
      return response;
    },
    // createVote: async (request: VoteCategoryCreate) => {
    //   const response: Vote = await client.post("/votes/new");
    //   return response;
    // },
    editVote: async (id: string | number, request: VoteCategoryEdit) => {
      const response: Vote = await client.put(`/votes/${id}/edit`, request);
      return response;
    },
    castVote: async (id: string | number, request: VoteCategoryCast) => {
      const response: Vote = await client.put(`/votes/${id}/cast`, request);
      return response;
    },
  },
};

export default GalaService;
