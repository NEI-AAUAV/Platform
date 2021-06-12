import React from "react";

import FloatingBtn from './Components/FloatingBtn';
import { useRoutes } from 'react-router-dom';
import routes from './routes';

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faComment } from '@fortawesome/free-solid-svg-icons';

const App = () => {
    const routing = useRoutes(routes);

    return (
        <>
            <FloatingBtn 
                location="bottomRight"
                content={<FontAwesomeIcon icon={faComment} />}
                title="Dá-nos o teu feedback!"
                onClick={() => alert("CLICKED")}
            />
            {routing}
        </>
    );
}

export default App;