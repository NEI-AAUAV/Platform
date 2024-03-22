import MainLayout from "@/pages/layout";
import { Navigate, type RouteObject } from "react-router-dom";

const routes: RouteObject[] = [
  {
    path: "/",
    element: <MainLayout />,
    children: [
      {
        path: "/",
        element: <Navigate to="/scoreboard" />,
      },
      {
        path: "/scoreboard",
        async lazy() {
          const { default: Scoreboard } = await import("@/pages/scoreboard");
          return { Component: Scoreboard };
        },
      },
      {
        path: "/maps",
        async lazy() {
          const { default: Maps } = await import("@/pages/maps");
          return { Component: Maps };
        },
      },
      {
        path: "/teams",
        async lazy() {
          const { default: Teams } = await import("@/pages/teams");
          return { Component: Teams };
        },
      },
      {
        path: "/teams/:id",
        async lazy() {
          const { default: TeamsById } = await import("@/pages/teams/[id]");
          return { Component: TeamsById };
        },
      },
      {
        path: "/admin",
        async lazy() {
          const { default: Admin } = await import("@/pages/admin");
          return { Component: Admin };
        },
      },
    ],
  },
];

export default routes;
