import { create } from "zustand";

interface GalaUserStore {
  _id?: number;
  matriculation?: number;
  nmec?: number;
  email?: string;
  name?: string;
  has_payed?: boolean;
  inGala: () => boolean;
}

const useGalaUserStore = create<GalaUserStore>((set, get) => ({
  inGala: () => !!get().nmec,
}));

export { useGalaUserStore };
