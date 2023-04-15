import { useRoutes } from 'react-router-dom';

import routes from './routes';

import { getSocket } from "services/SocketService"; 


let ws = getSocket();

const App = () => {
    const routing = useRoutes(routes);
    return routing;
}

export default App;
