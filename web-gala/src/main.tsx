import React from "react";
import ReactDOM from "react-dom/client";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import "./index.css";

//* Pages
import Home from "./pages/Home";
import ErrorBoundary from "./pages/ErrorBoundary";
import Layout from "./pages/Layout";

const router = createBrowserRouter(
  [
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
  ],
  {
    basename: "/gala",
  },
);

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
);
