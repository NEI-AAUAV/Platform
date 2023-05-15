import { RouterProvider, createBrowserRouter } from "react-router-dom";
import routes from "./routes";

export default function Router() {
  const router = createBrowserRouter(routes, {
    basename: "/gala",
  });

  return <RouterProvider router={router} />;
}
