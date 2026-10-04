import { useEffect } from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

import routes from "./routes";

import { getSocket } from "services/SocketService";
import { refreshToken } from "services/client";
import { QueryClient, QueryClientProvider } from "react-query";

getSocket();
const queryClient = new QueryClient();
const router = createBrowserRouter(routes);

/**
 * Render the pages with protected routes, after knowing if a session exists.
 *
 * This avoids wrong redirects when the application assumes a session does not exist
 * while it is waiting for the server response.
 */
const App = () => {
  useEffect(() => {
    refreshToken().catch((error) => {
      console.error("Failed to refresh token", String(error?.message ?? "unknown").replaceAll(/[\r\n]/g, " "));
    });
  }, []);

  return (
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  );
};

export default App;
