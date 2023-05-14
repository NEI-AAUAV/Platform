//* Pages
import Layout from "../pages/Layout";
import ErrorBoundary from "../pages/ErrorBoundary";
import Home from "../pages/Home";
import Reserve from "../pages/Reserve";

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
      {
        path: "/tables",
        element: <Reserve />,
      },
    ],
  },
];

export default routes;
