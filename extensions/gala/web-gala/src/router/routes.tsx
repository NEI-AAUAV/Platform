import { Navigate } from "react-router-dom";

//* Pages
import Layout from "@/pages/Layout";
import ErrorBoundary from "@/pages/ErrorBoundary";

const routes = [
  {
    path: "/",
    element: <Layout />,
    errorElement: <ErrorBoundary />,
    children: [
      {
        path: "/",
        async lazy() {
          const { default: Home } = await import("@/pages/Home");
          return { Component: Home };
        },
      },
      {
        path: "/reserve",
        async lazy() {
          const { default: Reserve } = await import("@/pages/Reserve");
          return { Component: Reserve };
        },
        children: [
          {
            path: "/reserve/:tableId",
            async lazy() {
              const { default: Reserve } = await import("@/pages/Reserve");
              return { Component: Reserve };
            },
          },
        ],
      },
      {
        path: "/vote",
        async lazy() {
          const { default: Vote } = await import("@/pages/Vote");
          return { Component: Vote };
        },
      },
      {
        path: "/register",
        async lazy() {
          const { default: Register } = await import("@/pages/Register");
          return { Component: Register };
        },
      },
      {
        path: "*",
        element: <Navigate to="/" />,
      },
    ],
  },
];

export default routes;
