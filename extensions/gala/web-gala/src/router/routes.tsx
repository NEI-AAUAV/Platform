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
        path: "/tables",
        async lazy() {
          const { default: Tables } = await import("@/pages/Tables");
          return { Component: Tables };
        },
      },
      {
        path: "/vote",
        async lazy() {
          const { default: Vote } = await import("@/pages/Vote");
          return { Component: Vote };
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
