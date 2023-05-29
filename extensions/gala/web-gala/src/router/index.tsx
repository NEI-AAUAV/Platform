import { useEffect } from "react";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import routes from "./routes";
import { refreshToken } from "src/services/client";

export default function Router() {
  const router = createBrowserRouter(routes, {
    basename: "/gala",
  });

  useEffect(() => {
    refreshToken();
  }, []);

  return <RouterProvider router={router} />;
}
