import { create } from "zustand";

interface GalaUserStore {
  _id?: number;
  matriculation?: number;
  nmec?: number;
  email?: string;
  name?: string;
  has_payed?: boolean;
}

const useGalaUserStore = create<GalaUserStore>(() => ({
}));

export { useGalaUserStore };
