import React from "react";

import { useRoutes } from 'react-router-dom';
import routes from './routes';

import { library } from '@fortawesome/fontawesome-svg-core'
import { faFilePdf, faFolder, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons'

// Register Fontawesome icons
// https://fontawesome.com/v5.15/how-to-use/on-the-web/using-with/react (Using Icons via Global Use)
library.add(fab, faFilePdf, faFolder, faCloudDownloadAlt);

const App = () => {
    let buffer = "";
    const routing = useRoutes(routes);

    return (
        <div>
            {routing}
        </div>
    );
}

export default App;
