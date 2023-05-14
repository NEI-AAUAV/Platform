//* Pages
import Layout from "@/pages/Layout";
import ErrorBoundary from "@/pages/ErrorBoundary";
import Home from "@/pages/Home";
import Reserve from "@/pages/Reserve";
import Vote from "@/pages/Vote";

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
      {
        path: "/gala/vote",
        element: <Vote />,
      },
    ],
  },
];

export default routes;
