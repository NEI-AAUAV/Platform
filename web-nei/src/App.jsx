import { useEffect } from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

import routes from "./routes";

import { getSocket } from "services/SocketService";
import { useUserStore } from "stores/useUserStore";
import { refreshToken } from "services/client";

let ws = getSocket();

/**
 * Render the pages with protected routes, after knowing if a session exists.
 * 
 * This avoids wrong redirects when the application assumes a session does not exist 
 * while it is waiting for the server response.
 */
const App = () => {
  const { sessionLoading, token } = useUserStore((state) => state);
  const router = createBrowserRouter(routes({ isAuth: !!token }));

  useEffect(() => {
    refreshToken();
  }, []);

  return sessionLoading ? null : <RouterProvider router={router} />;
};

export default App;
