import React, { useState, useEffect } from "react";

import FloatingBtns from './Components/FloatingBtns';
import { useRoutes } from 'react-router-dom';
import routes from './routes';

import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faComment, faChevronUp, faFilePdf, faFolder, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons'

import {useTheme} from 'Stores/useTheme';

// Register Fontawesome icons
// https://fontawesome.com/v5.15/how-to-use/on-the-web/using-with/react (Using Icons via Global Use)
library.add(fab, faFilePdf, faFolder, faCloudDownloadAlt);

const App = () => {
    const routing = useRoutes(routes);


    // Back to top button
    const [top, setTop] = useState(true);
    useEffect(() => {
        window.addEventListener('scroll', scrollHandler);
    }, [document.documentElement.scrollTop, window.pageYOffset]);

    const scrollHandler = () => {
        var top = window.pageYOffset || document.documentElement.scrollTop;
        if (top > 100) {
            setTop(false);
        } else {
            setTop(true);
        }
    }
    
    //const theme = useTheme(state => state.theme);
    const theme = localStorage.getItem('theme', useTheme(state => state.theme));

    return (
        <div data-theme={theme}>
            <FloatingBtns location="bottomRight">
                {
                    !top &&
                    <button
                        className="btn btn-outline-primary btn-outline-primary-force rounded-circle mt-1 animation"
                        title="Voltar ao topo"
                        onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                    >
                        <FontAwesomeIcon icon={faChevronUp} />
                    </button>
                }
                {
                    window.location.href.indexOf("/forms/feedback") < 0
                    &&
                    <button
                        className="btn  btn-outline-primary btn-outline-primary-force rounded-circle mt-1 animation"
                        title="Dá-nos o teu feedback!"
                        onClick={() => window.location.replace("/forms/feedback")}
                    >
                        <FontAwesomeIcon icon={faComment} />
                    </button>
                }
            </FloatingBtns>
            {routing}
        </div>
    );
}

export default App;