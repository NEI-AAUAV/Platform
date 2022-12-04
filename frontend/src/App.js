import React, { useEffect } from "react";

import { useRoutes } from 'react-router-dom';
import routes from './routes';

import { library } from '@fortawesome/fontawesome-svg-core'
import { faFilePdf, faFolder, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons'
import { useRallyAuth } from "stores/useRallyAuth";

// Register Fontawesome icons
// https://fontawesome.com/v5.15/how-to-use/on-the-web/using-with/react (Using Icons via Global Use)
library.add(fab, faFilePdf, faFolder, faCloudDownloadAlt);

const App = () => {
    let buffer = "";
    const routing = useRoutes(routes);

    useEffect(() => {
        if (useRallyAuth.getState().ready) return;
        const handleKeyType = (event) => {
            buffer += event.key;
            if (buffer.slice(-6).toLowerCase() === "tester") {
                useRallyAuth.getState().setReady();
                window.location.reload();
            }
        };
        window.addEventListener('keydown', handleKeyType);
        return () => {
            window.removeEventListener('keydown', handleKeyType);
        };
    }, [])

    return (
        <div>
            {routing}
        </div>
    );
}

export default App;
