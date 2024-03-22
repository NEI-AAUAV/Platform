import { RouterProvider, createBrowserRouter } from "react-router-dom";
import routes from "./routes";

const router = createBrowserRouter(routes, {
  basename: "/rally",
});

export default function Router() {
  return <RouterProvider router={router} />;
}
