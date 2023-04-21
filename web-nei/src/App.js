import { useRoutes } from "react-router-dom";

import routes from "./routes";

import { getSocket } from "services/SocketService";
import { useUserStore } from "stores/useUserStore";

let ws = getSocket();

const AuthenticatedRoutes = () => {
  return useRoutes(routes({ isAuth: true }));
};

const UnauthenticatedRoutes = () => {
  return useRoutes(routes({ isAuth: false }));
};

/**
 * Render the pages with protected routes, after knowing if a session exists.
 * 
 * This avoids wrong redirects when the application assumes a session does not exist 
 * while it is waiting for the server response.
 */
const App = () => {
  const { sessionLoading, token } = useUserStore((state) => state);
  if (sessionLoading) {
    return null;
  } else if (token) {
    return <AuthenticatedRoutes />;
  } else {
    return <UnauthenticatedRoutes />;
  }
};

export default App;
