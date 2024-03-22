import { TabsProps } from "./types";

export const tabs: TabsProps = [
  {
    name: "Jogos",
    url: "games",
    isAdminOnly: false,
  },
  {
    name: "Classificações",
    url: "standings",
    isAdminOnly: false,
  },
  {
    name: "Equipa",
    url: "team",
    isAdminOnly: false,
  },
  {
    name: "Grupos",
    url: "groups",
    isAdminOnly: true,
  },
  {
    name: "Competições",
    url: "competitions",
    isAdminOnly: true,
  },
];
