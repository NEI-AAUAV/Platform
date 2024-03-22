import { useEffect } from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

import routes from "./routes";

import { getSocket } from "services/SocketService";
import { refreshToken } from "services/client";
import { QueryClient, QueryClientProvider } from "react-query";

let ws = getSocket();
const queryClient = new QueryClient();

/**
 * Render the pages with protected routes, after knowing if a session exists.
 *
 * This avoids wrong redirects when the application assumes a session does not exist
 * while it is waiting for the server response.
 */
const App = () => {
  const router = createBrowserRouter(routes);

  useEffect(() => {
    refreshToken();
  }, []);

  return (
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  );
};

export default App;
