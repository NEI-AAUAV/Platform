import React from "react";

import {
    useParams
} from "react-router-dom";

const Error404 = () => {
    let { id } = useParams();

    return (
        <div>
            <h1>Error 404</h1>
        </div>
    );
}

export default Error404;