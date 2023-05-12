import Layout from "../pages/Layout";
import Home from "../pages/Home";
import ErrorBoundary from "../pages/ErrorBoundary";

const routes = [
  {
    path: "/",
    element: <Layout />,
    errorElement: <ErrorBoundary />,
    children: [
      {
        path: "/",
        element: <Home />,
      },
    ],
  },
];

export default routes;
