//* Pages
import Layout from "../pages/Layout";
import ErrorBoundary from "../pages/ErrorBoundary";
import Home from "../pages/Home";
import Reserve from "../pages/Reserve";

const routes = [
  {
    path: "/gala",
    element: <Layout />,
    errorElement: <ErrorBoundary />,
    children: [
      {
        path: "/gala",
        element: <Home />,
      },
      {
        path: "/gala/tables",
        element: <Reserve />,
      },
    ],
  },
];

export default routes;
