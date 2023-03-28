import { useRoutes } from 'react-router-dom';
import { library } from '@fortawesome/fontawesome-svg-core';
import { faFilePdf, faFolder, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';

import routes from './routes';

import { getSocket } from "services/SocketService"; 

// Register Fontawesome icons
// https://fontawesome.com/v5.15/how-to-use/on-the-web/using-with/react (Using Icons via Global Use)
library.add(fab, faFilePdf, faFolder, faCloudDownloadAlt);

let ws = getSocket();

const App = () => {
    const routing = useRoutes(routes);
    return routing;
}

export default App;
