//* Pages
import Layout from "@/pages/Layout";
import ErrorBoundary from "@/pages/ErrorBoundary";
import Home from "@/pages/Home";
import Reserve from "@/pages/Reserve";
import Vote from "@/pages/Vote";

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
      {
        path: "/vote",
        element: <Vote />,
      },
    ],
  },
];

export default routes;
