import { RouterProvider, createBrowserRouter } from "react-router-dom";
import { useUserStore } from "@/stores/useUserStore";
import routes from "./routes";

export default function Router() {
  const router = createBrowserRouter(routes, {
    basename: "/gala",
  });
  const sessionLoading = useUserStore((state) => state.sessionLoading);

  return sessionLoading ? null : <RouterProvider router={router} />;
}
